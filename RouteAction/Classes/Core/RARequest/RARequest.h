//
//  RARequest.h
//  RouteAction
//
//  Created by GuangYu on 2017/12/29.
//

#import <Foundation/Foundation.h>
@class RAResponse;

@interface RARequest : NSObject

@property (nonatomic, readonly) NSURL *url;
@property (nonatomic, readonly) NSDictionary *params;

- (void)appendParams:(NSDictionary *)params;
- (instancetype)onResponse:(void(^)(RAResponse *response))responseCallback;
- (instancetype)onComplete:(void(^)(NSError *error))completeCallback;

+ (instancetype)requestWithURL:(NSString *)URLString;
+ (instancetype)requestWithURL:(NSString *)URLString params:(NSDictionary *)params;

@end
