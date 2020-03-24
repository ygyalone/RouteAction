//
//  RARouter.h
//  RouteAction
//
//  Created by GuangYu on 2017/12/29.
//

#import <Foundation/Foundation.h>
#import "RARequest.h"
#import "RARequestHandler.h"
#import "RAIntercepter.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^RAResponseBlock)(RARequest * request, RARequestHandler *handler);

@interface RARouter : NSObject

+ (instancetype)shared;
///发送请求
- (void)sendRequest:(RARequest *)request;
///注册动作
- (BOOL)registerActionWithURLPattern:(NSString *)URLPattern block:(RAResponseBlock)block;
///注册拦截器
- (BOOL)registerIntercepter:(RAIntercepter *)intercepter withURLPattern:(NSString *)URLPattern;
///注销节点
- (BOOL)deregisterWithURLPattern:(NSString *)URLPattern;
///全局404配置
- (void)configGlobalMissmatch:(void(^)(RARequest *request))block;

@end

NS_ASSUME_NONNULL_END
