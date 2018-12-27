//
//  CustomPresentTransition.h
//  RouteAction_Example
//
//  Created by GuangYu on 2018/2/27.
//  Copyright © 2018年 ygyalone. All rights reserved.
//

#import <Foundation/Foundation.h>
@import RouteAction;

@interface CustomPresentTransition : NSObject <RATransitionDisplay>
@property (nonatomic, copy) UINavigationController *(^navigationControllerConstructor)(UIViewController *root);
@end
