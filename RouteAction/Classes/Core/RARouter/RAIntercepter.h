//
//  RAIntercepter.h
//  RouteAction
//
//  Created by GuangYu on 2017/12/29.
//

#import <Foundation/Foundation.h>
#import "RARequest.h"

@protocol RAIntercepterJudger<NSObject>

@property (nonatomic, readonly) void(^doContinue)(void);
@property (nonatomic, readonly) void(^doReject)(NSError *error);
@property (nonatomic, readonly) void(^doSwitch)(NSString *path);

@end

#define RAIntercepterPriorityLow        250
#define RAIntercepterPriorityNormal     500
#define RAIntercepterPriorityHigh       1000

@interface RAIntercepter : NSObject
@property (nonatomic, assign) NSInteger priority;
@property (nonatomic, readonly) void(^awake)(RARequest *request, id<RAIntercepterJudger> judger);
+ (instancetype)intercepterWithAwake:(void(^)(RARequest *request, id<RAIntercepterJudger> judger))awake;
- (NSComparisonResult)compare:(RAIntercepter *)intercepter;
@end
