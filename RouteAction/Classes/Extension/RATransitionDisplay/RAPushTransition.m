//
//  RAPushTransition.m
//  RouteAction
//
//  Created by GuangYu on 2018/2/2.
//

#import "RAPushTransition.h"

@implementation RAPushTransition

- (void)displayFromViewController:(UIViewController *)from toViewController:(UIViewController *)to animated:(BOOL)animated completion:(void(^)(void))completion {
    if (!from.navigationController) {
        RALog(@"Error: viewController:%@ not in navigation stack when pushed!", from);
        return;
    }
    
    [self _doTransition:^{
        [from.navigationController pushViewController:to animated:animated];
    } animated:animated completion:completion];
}

- (void)finishDisplayFromViewController:(UIViewController *)from toViewController:(UIViewController *)to animated:(BOOL)animated completion:(void(^)(void))completion {
    
    [self _doTransition:^{
        
        if (to && [from.navigationController.viewControllers indexOfObject:to] != NSNotFound) {
            [from.navigationController popToViewController:to animated:animated];
        }else {
            [from.navigationController popViewControllerAnimated:animated];
        }
        
    } animated:animated completion:completion];
}

- (void)_doTransition:(void(^)(void))transition
             animated:(BOOL)animated
           completion:(void(^)(void))completion {
    
    if (!animated) {
        if (completion) {
            completion();
        }
        transition();
    }else {
        if (completion) {
            [CATransaction begin];
            [CATransaction setCompletionBlock:^{
                completion();
            }];
            transition();
            [CATransaction commit];
        }else {
            transition();
        }
    }
}

@end
