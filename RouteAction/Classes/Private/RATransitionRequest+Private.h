//
//  RATransitionRequest+Private.h
//  RouteAction
//
//  Created by GuangYu on 2018/2/26.
//

#import "RATransitionRequest.h"

@interface RATransitionRequest (Private)
@property (nonatomic, copy) void(^transitionCompleteCallback)(RATransitionRequest *request);
@end
