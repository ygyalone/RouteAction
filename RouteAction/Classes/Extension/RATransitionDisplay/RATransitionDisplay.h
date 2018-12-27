//
//  RATransitionDisplay.h
//  RouteAction
//
//  Created by GuangYu on 2018/1/3.
//

#import <Foundation/Foundation.h>

@class UIViewController;

@protocol RATransitionDisplay <NSObject>

- (void)displayFromViewController:(UIViewController *)from
                 toViewController:(UIViewController *)to
                         animated:(BOOL)animated
                       completion:(void(^)(void))completion;

- (void)finishDisplayFromViewController:(UIViewController *)from
                       toViewController:(UIViewController *)to
                               animated:(BOOL)animated
                             completion:(void(^)(void))completion;
@end
