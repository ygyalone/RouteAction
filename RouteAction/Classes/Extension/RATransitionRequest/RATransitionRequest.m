//
//  RATransitionRequest.m
//  RouteAction
//
//  Created by GuangYu on 2018/1/3.
//

#import "RATransitionRequest.h"
#import "RATransitionRequest+Private.h"
#import "RAPushTransition.h"
#import "RAPresentTransition.h"
#import "RATransitionResponse.h"

@interface RATransitionRequest()
@property (nonatomic, strong) Class targetClass;
@property (nonatomic, copy) void(^transitionCompleteCallback)(RATransitionRequest *request);
@end

@implementation RATransitionRequest
#pragma mark - override
+ (instancetype)requestWithURL:(NSString *)URLString params:(NSDictionary *)params {
    RATransitionRequest *request = [super requestWithURL:URLString params:params];
    request.transitionAnimated = YES;
    return request;
}

- (NSString *)description {
    return @{@"controller":self.targetClass?:@"",@"url":self.url?:@"",@"params":self.params?:@{}}.description;
}

- (instancetype)onResponse:(void (^)(RATransitionResponse *))responseCallback {
    __weak typeof(self) weak_self = self;
    return [super onResponse:^(RAResponse *response) {
        typeof(weak_self) self = weak_self;
        //尴尬 NSAssert宏展开后会引用self
        NSAssert([response isKindOfClass:[RATransitionResponse class]],
                 @"Error: transition response(%@) is not kind of Class:RATransitionResponse", response);
        ra_exeBlock(responseCallback, (RATransitionResponse *)response);
    }];
}

#pragma mark - public
- (void)onTransitionComplete:(void (^)(RATransitionRequest *))callback {
    self.transitionCompleteCallback = callback;
}

#pragma mark - request without transitionDisplay
+ (RATransitionRequest *)requestWithControllerClass:(Class)controllerClass {
    return [self requestWithControllerClass:controllerClass params:nil];
}

+ (RATransitionRequest *)requestWithControllerClass:(Class)controllerClass params:(NSDictionary *)params {
    RATransitionRequest *request = [self requestWithURL:nil params:params];
    request.targetClass = controllerClass;
    return request;
}

#pragma mark - request with RAPushTransition
+ (RATransitionRequest *)pushTransitionRequestWithURL:(NSString *)URL {
    return [self pushTransitionRequestWithURL:URL params:nil];
}

+ (RATransitionRequest *)pushTransitionRequestWithURL:(NSString *)URL params:(NSDictionary *)params {
    RATransitionRequest *request = [self requestWithURL:URL params:params];
    request.transitionDisplay = [RAPushTransition new];
    return request;
}

+ (RATransitionRequest *)pushTransitionRequestWithControllerClass:(Class)controllerClass {
    return [self pushTransitionRequestWithControllerClass:controllerClass params:nil];
}

+ (RATransitionRequest *)pushTransitionRequestWithControllerClass:(Class)controllerClass params:(NSDictionary *)params {
    RATransitionRequest *request = [self requestWithControllerClass:controllerClass params:params];
    request.transitionDisplay = [RAPushTransition new];
    return request;
}

#pragma mark - request with RAPresentTransition
+ (RATransitionRequest *)presentTransitionRequestWithURL:(NSString *)URL {
    return [self presentTransitionRequestWithURL:URL params:nil];
}

+ (RATransitionRequest *)presentTransitionRequestWithURL:(NSString *)URL params:(NSDictionary *)params {
    RATransitionRequest *request = [self requestWithURL:URL params:params];
    request.transitionDisplay = [RAPresentTransition new];
    return request;
}

+ (RATransitionRequest *)presentTransitionRequestWithControllerClass:(Class)controllerClass {
    return [self presentTransitionRequestWithControllerClass:controllerClass params:nil];
}

+ (RATransitionRequest *)presentTransitionRequestWithControllerClass:(Class)controllerClass params:(NSDictionary *)params {
    RATransitionRequest *request = [self requestWithControllerClass:controllerClass params:params];
    request.transitionDisplay = [RAPresentTransition new];
    return request;
}

@end
