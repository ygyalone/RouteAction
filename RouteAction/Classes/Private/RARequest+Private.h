//
//  RARequest+Private.h
//  RouteAction
//
//  Created by GuangYu on 2018/2/26.
//

#import "RARequest.h"
@class RAResponse;

@interface RARequest (Private)
@property (nonatomic, copy) void (^responseCallback)(RAResponse *response);
@property (nonatomic, copy) void (^completeCallback)(NSError *error);
- (void)dispatchTo:(NSString *)path;///<请求转发
@end
