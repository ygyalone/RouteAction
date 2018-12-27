//
//  RARequest.m
//  RouteAction
//
//  Created by GuangYu on 2017/12/29.
//

#import "RARequest.h"
#import "RARequest+Private.h"

@interface RARequest()
@property (nonatomic, copy) NSURL *url;
@property (nonatomic, strong) NSMutableDictionary *params;
@property (nonatomic, copy) void (^responseCallback)(RAResponse *response);
@property (nonatomic, copy) void (^completeCallback)(NSError *error);
@end

@implementation RARequest

- (instancetype)init {
    NSAssert(NO, @"Error: init method was forbidden!");
    return nil;
}

- (instancetype)initWithURL:(NSString *)URLString params:(NSDictionary *)params {
    if (self = [super init]) {
        NSURL *url = [NSURL URLWithString:URLString];
        self.url = url;
        self.params = (params?:@{}).mutableCopy;
        
        //append url query params
        if (url) {
            [[NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:YES].queryItems
             enumerateObjectsUsingBlock:^(NSURLQueryItem * _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
                 if (item.name && item.value) {
                     [self appendParams:@{item.name:item.value}];
                 }
             }];
        }
    }
    return self;
}

- (void)dispatchTo:(NSString *)path {
    self.url = [NSURL URLWithString:path];
}

#pragma mark - setter
- (void)setCompleteCallback:(void (^)(NSError *))completeCallback {
    void (^cb)(NSError *);
    if (completeCallback) {
        __weak typeof(self) weak_self = self;
        cb = ^(NSError *error) {
            completeCallback(error);
            //active only once
            weak_self.completeCallback = nil;
            weak_self.responseCallback = nil;
        };
    }
    
    _completeCallback = [cb copy];
}

#pragma mark - public method
+ (instancetype)requestWithURL:(NSString *)URLString {
    return [self requestWithURL:URLString params:nil];
}

+(instancetype)requestWithURL:(NSString *)URLString params:(NSDictionary *)params {
    return [[self alloc] initWithURL:URLString params:params];
}

- (void)appendParams:(NSDictionary *)params {
    NSMutableDictionary *appendedParams = [NSMutableDictionary dictionary];
    [params.allKeys enumerateObjectsUsingBlock:^(id  _Nonnull key, NSUInteger idx, BOOL * _Nonnull stop) {
        [appendedParams setObject:params[key] forKey:key];
    }];
    [_params addEntriesFromDictionary:appendedParams];
}

- (instancetype)onResponse:(void (^)(RAResponse *))responseCallback {
    self.responseCallback = responseCallback;
    return self;
}

- (instancetype)onComplete:(void (^)(NSError *))completeCallback {
    self.completeCallback = completeCallback;
    return self;
}

#pragma mark - description
- (NSString *)description {
    return @{@"url":self.url?:@"",@"params":self.params?:@{}}.description;
}

@end
