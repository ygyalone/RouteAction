//
//  RATransitionRequest.h
//  RouteAction
//
//  Created by GuangYu on 2018/1/3.
//

#import "RARequest.h"
#import "RATransitionDisplay.h"
@class UIViewController;
@class RATransitionResponse;

@interface RATransitionRequest : RARequest

@property (nonatomic, readonly) Class targetClass;
@property (nonatomic, weak) UIViewController *requester;

@property (nonatomic, strong) id<RATransitionDisplay> transitionDisplay;
@property (nonatomic, assign) BOOL transitionAnimated;

- (void)onTransitionComplete:(void (^)(RATransitionRequest *request))callback;

//override method
- (instancetype)onResponse:(void (^)(RATransitionResponse *response))responseCallback;

//request without transitionDisplay
+ (RATransitionRequest *)requestWithControllerClass:(Class)controllerClass;
+ (RATransitionRequest *)requestWithControllerClass:(Class)controllerClass params:(NSDictionary *)params;

//request with RAPushTransition
+ (RATransitionRequest *)pushTransitionRequestWithURL:(NSString *)URL;
+ (RATransitionRequest *)pushTransitionRequestWithURL:(NSString *)URL params:(NSDictionary *)params;
+ (RATransitionRequest *)pushTransitionRequestWithControllerClass:(Class)controllerClass;
+ (RATransitionRequest *)pushTransitionRequestWithControllerClass:(Class)controllerClass params:(NSDictionary *)params;

//request with RAPresentTransition
+ (RATransitionRequest *)presentTransitionRequestWithURL:(NSString *)URL;
+ (RATransitionRequest *)presentTransitionRequestWithURL:(NSString *)URL params:(NSDictionary *)params;
+ (RATransitionRequest *)presentTransitionRequestWithControllerClass:(Class)controllerClass;
+ (RATransitionRequest *)presentTransitionRequestWithControllerClass:(Class)controllerClass params:(NSDictionary *)params;

@end

