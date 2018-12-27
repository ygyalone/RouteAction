//
//  RAPresentTransition.m
//  RouteAction
//
//  Created by GuangYu on 2018/2/2.
//

#import "RAPresentTransition.h"

@implementation RAPresentTransition

- (void)displayFromViewController:(UIViewController *)from
                 toViewController:(UIViewController *)to
                         animated:(BOOL)animated
                       completion:(void(^)(void))completion {
    
    UINavigationController *nav = nil;
    if (self.navigationControllerConstructor) {
        nav = self.navigationControllerConstructor(to);
    }else {
        nav = [[UINavigationController alloc] initWithRootViewController:to];
    }
    
    [from presentViewController:nav animated:animated completion:^{
        if (completion) {
            completion();
        }
    }];
}

- (void)finishDisplayFromViewController:(UIViewController *)from
                       toViewController:(UIViewController *)to
                               animated:(BOOL)animated
                             completion:(void(^)(void))completion {
    [from.presentingViewController dismissViewControllerAnimated:animated completion:^{
        if (completion) {
            completion();
        }
    }];
}

@end
