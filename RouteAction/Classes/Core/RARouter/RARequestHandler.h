//
//  RARequestHandler.h
//  RouteAction
//
//  Created by GuangYu on 2018/8/26.
//

#import <Foundation/Foundation.h>
@class RAResponse;

@interface RARequestHandler <T:RAResponse *>: NSObject
@property (nonatomic, readonly) void (^response)(T);
@property (nonatomic, readonly) void (^complete)(NSError *error);
@end
