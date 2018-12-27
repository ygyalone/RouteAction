//
//  RARequestHandler+Private.h
//  RouteAction
//
//  Created by GuangYu on 2018/8/26.
//

#import "RARequestHandler.h"

@interface RARequestHandler<T> (Private)
@property (nonatomic, copy) void (^responseCallback)(T);
@property (nonatomic, copy) void (^completeCallback)(NSError *error);
- (instancetype)initWithResponse:(void(^)(T response))response
                        complete:(void(^)(NSError *error))complete;
@end
