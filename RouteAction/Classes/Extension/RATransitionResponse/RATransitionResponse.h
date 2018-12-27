//
//  RATransitionResponse.h
//  RouteAction
//
//  Created by GuangYu on 2018/8/26.
//

#import "RAResponse.h"
@class UIViewController;

@interface RATransitionResponse : RAResponse
@property (nonatomic, readonly, weak) UIViewController *responser;    ///<响应者
+ (instancetype)responseWithCode:(NSInteger)code data:(id)data responser:(UIViewController *)responser;
@end
