//
//  RARouter.m
//  RouteAction
//
//  Created by GuangYu on 2017/12/29.
//

#import "RARouter.h"
#import "RARequest+Private.h"
#import "RARequestHandler+Private.h"
#import "RATree.h"
#import "NSURL+RAPathParsing.h"

#pragma mark - RANodeAttachment
@interface RANodeAttachment : NSObject

@property (nonatomic, copy) RAResponseBlock commonResponse;
@property (nonatomic, copy) RAResponseBlock specificResponse;
@property (nonatomic, readonly) NSArray<RAIntercepter *> *commonIntercepters;
@property (nonatomic, strong) NSArray<RAIntercepter *> *specificIntercepters;

- (void)insertCommonIntercepter:(RAIntercepter *)intercepter;
- (void)insertSpecificIntercepter:(RAIntercepter *)intercepter;

@end

@implementation RANodeAttachment {
    NSMutableArray<RAIntercepter *> *_commonIntercepters;
    NSMutableArray<RAIntercepter *> *_specificIntercepters;
}

- (instancetype)init {
    if (self = [super init]) {
        _commonIntercepters = @[].mutableCopy;
        _specificIntercepters = @[].mutableCopy;
    }
    return self;
}

- (void)insertCommonIntercepter:(RAIntercepter *)intercepter {
    [self insertIntercepter:intercepter to:_commonIntercepters];
}

- (void)insertSpecificIntercepter:(RAIntercepter *)intercepter {
    [self insertIntercepter:intercepter to:_specificIntercepters];
}

- (void)insertIntercepter:(RAIntercepter *)intercepter to:(NSMutableArray<RAIntercepter *> *)intercepters {
    if ([intercepters containsObject:intercepter]) {
        return;
    }
    
    [intercepters addObject:intercepter];
    [intercepters sortUsingComparator:^NSComparisonResult(RAIntercepter *  _Nonnull obj1, RAIntercepter *  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
}

- (NSArray<RAIntercepter *> *)commonIntercepters {
    return _commonIntercepters;
}

- (NSArray<RAIntercepter *> *)specificIntercepters {
    return _specificIntercepters;
}

@end

#pragma mark - _RAIntercepterJudger
@interface _RAIntercepterJudger : NSObject <RAIntercepterJudger>
- (instancetype)initWithDoContinue:(void (^)(void))doContinue
                          doReject:(void(^)(NSError *error))doReject
                          doSwitch:(void(^)(NSString *path))doSwitch;
@end

@implementation _RAIntercepterJudger {
    void(^_doContinue)(void);
    void(^_doReject)(NSError *error);
    void(^_doSwitch)(NSString *path);
}

- (instancetype)initWithDoContinue:(void (^)(void))doContinue
                          doReject:(void (^)(NSError *error))doReject
                          doSwitch:(void (^)(NSString *path))doSwitch {
    if (self = [super init]) {
        NSAssert(doContinue&&doReject&&doSwitch, @"Error: block can not be nil");
        _doContinue = doContinue;
        _doReject = doReject;
        _doSwitch = doSwitch;
    }
    return self;
}

- (void (^)(void))doContinue {
    return ^(){
        ra_exeBlock(self->_doContinue);
        self->_doReject = nil;
        self->_doSwitch = nil;
    };
}

- (void (^)(NSError *))doReject {
    return ^(NSError *error){
        ra_exeBlock(self->_doReject, error);
        self->_doContinue = nil;
        self->_doSwitch = nil;
    };
}

- (void (^)(NSString *))doSwitch {
    return ^(NSString *path) {
        ra_exeBlock(self->_doSwitch, path);
        self->_doContinue = nil;
        self->_doReject = nil;
    };
}

@end

#pragma mark - RARouter
@interface RARouter ()
@property (nonatomic, strong) RATree<RANodeAttachment *> *pathTree;
@property (nonatomic, copy) void(^gloabalMissmatch)(RARequest *);
@end

@implementation RARouter
#pragma mark - public
- (instancetype)init {
    if (self = [super init]) {
        self.pathTree = [RATree new];
    }
    return self;
}

+ (instancetype)shared {
    static RARouter *router = nil;
    @synchronized(self) {
        if (!router) {
            router = [RARouter new];
        }
    }
    return router;
}

- (void)configGlobalMissmatch:(void(^)(RARequest *request))block {
    self.gloabalMissmatch = block;
}

- (BOOL)registerActionWithURLPattern:(NSString *)URLPattern block:(RAResponseBlock)block {
    NSURL *url = [NSURL URLWithString:URLPattern];
    RANode<RANodeAttachment *> *node = [self.pathTree insertNodeByPaths:url.ra_pathsOfPattern];
    return [self insertResponse:block to:node withURLPattern:url];
}

- (BOOL)registerIntercepter:(RAIntercepter *)intercepter withURLPattern:(NSString *)URLPattern {
    NSURL *url = [NSURL URLWithString:URLPattern];
    RANode<RANodeAttachment *> *node = [self.pathTree insertNodeByPaths:url.ra_pathsOfPattern];
    return [self insertIntercepter:intercepter to:node withURLPattern:url];
}

- (BOOL)deregisterWithURLPattern:(NSString *)URLPattern {
    NSURL *url = [NSURL URLWithString:URLPattern];
    BOOL forced = url.ra_isCommonPattern;
    return [self.pathTree removeNodeByPaths:url.ra_pathsOfPattern forced:forced];
}

- (void)sendRequest:(RARequest *)request {
    NSArray *paths = request.url.ra_pathsOfRequest;
    RANode<RANodeAttachment *> *node = [self.pathTree searchNodeByPaths:paths];
    
    //执行拦截器
    NSArray<RAIntercepter *> *intercepters = [self interceptersOfNode:node];
    [self runRequest:request withIntercepters:intercepters completion:^(RARequest *request) {
        //执行响应
        RAResponseBlock response = nil;
        response = [self responseOfNode:node withPaths:paths];
        if (!response) {
            RALog(@"%@", [NSString stringWithFormat:@"Error: can not find response bound to url:%@", request.url]);
            ra_exeBlock(self.gloabalMissmatch, request);
            return;
        }
        
        NSDictionary *pathParams = [self loadPathParams:paths ofNode:node];
        [request appendParams:pathParams];
        
        RARequestHandler *handler = [[RARequestHandler alloc] initWithResponse:^(RAResponse *response) {
            ra_exeBlock(request.responseCallback, response);
        } complete:^(NSError *error) {
            ra_exeBlock(request.completeCallback, error);
        }];
        response(request, handler);
    }];
}

#pragma mark - private
- (NSDictionary *)loadPathParams:(NSArray<NSString *> *)paths ofNode:(RANode *)node {
    if (!node) {
        return @{};
    }
    
    NSMutableDictionary *params = @{}.mutableCopy;
    do {
        if (node.isPlaceholder) {
            params[node.placeholder] = paths[node.depth-1];
        }
        node = node.superNode;
    } while (node);
    
    return params;
}

- (NSArray<RAIntercepter *> *)interceptersOfNode:(RANode<RANodeAttachment *> *)node {
    NSMutableArray *intercepters = [NSMutableArray array];
    [intercepters addObjectsFromArray:node.value.specificIntercepters];
    
    while (node) {
        if (node.value.commonIntercepters.count) {
            [intercepters addObjectsFromArray:node.value.commonIntercepters];
        }
        node = node.superNode;
    }
    
    return intercepters.copy;
}

- (RAResponseBlock)responseOfNode:(RANode<RANodeAttachment *> *)node withPaths:(NSArray<NSString *> *)paths {
    if (node.depth == paths.count && node.value.specificResponse) {
        return node.value.specificResponse;
    }
    
    while (node) {
        if (node.value.commonResponse) {
            return node.value.commonResponse;
        }
        node = node.superNode;
    }
    
    return nil;
}

- (BOOL)insertIntercepter:(RAIntercepter *)intercepter to:(RANode<RANodeAttachment *> *)node withURLPattern:(NSURL *)URLPattern {
    if (!node || !intercepter) {
        return NO;
    }
    
    if (!node.value) {
        node.value = [RANodeAttachment new];
    }
    
    if (URLPattern.ra_isCommonPattern) {
        [node.value insertCommonIntercepter:intercepter];
    }else {
        [node.value insertSpecificIntercepter:intercepter];
    }
    
    return YES;
}

- (BOOL)insertResponse:(RAResponseBlock)response to:(RANode<RANodeAttachment *> *)node withURLPattern:(NSURL *)URLPattern {
    if (!node || !response) {
        return NO;
    }
    
    if (!node.value) {
        node.value = [RANodeAttachment new];
    }
    
    if (URLPattern.ra_isCommonPattern) {
        if (node.value.commonResponse) {
            NSAssert(NO, @"Already has a common response bound to node(%@), can not register another one!", node);
            return NO;
        }
        node.value.commonResponse = response;
        
    }else {
        if (node.value.specificResponse) {
            NSAssert(NO, @"Already has a specific response bound to node(%@), can not register another one!", node);
            return NO;
        }
        node.value.specificResponse = response;
    }
    
    return YES;
}

- (void)runRequest:(RARequest *)request
  withIntercepters:(NSArray<RAIntercepter *> *)intercepters
        completion:(void(^)(RARequest *request))completion {
    
    if (!intercepters.count) {
        //拦截器执行完成
        ra_exeBlock(completion, request);
        return;
    }
    
    _RAIntercepterJudger *judger = [[_RAIntercepterJudger alloc] initWithDoContinue:^{
        NSUInteger count = intercepters.count;
        NSArray *subIntercepters = count > 1? [intercepters subarrayWithRange:NSMakeRange(1, count-1)] : @[] ;
        [self runRequest:request withIntercepters:subIntercepters completion:completion];
    } doReject:^(NSError *error) {
        ra_exeBlock(request.completeCallback, error);
    } doSwitch:^(NSString *path) {
        [request dispatchTo:path];
        [[RARouter shared] sendRequest:request];
    }];
    
    intercepters.firstObject.awake(request, judger);
}

@end
