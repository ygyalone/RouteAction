//
//  CustomPresentTransition.m
//  RouteAction_Example
//
//  Created by GuangYu on 2018/2/27.
//  Copyright © 2018年 ygyalone. All rights reserved.
//

#import "CustomPresentTransition.h"

@interface CustomPresentTransition () <UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning>
@property (nonatomic, assign) BOOL isPresent;
@end

@implementation CustomPresentTransition

#pragma mark - RATransitionDisplay
- (void)displayFromViewController:(UIViewController *)from toViewController:(UIViewController *)to animated:(BOOL)animated completion:(void (^)(void))completion {
    
    UINavigationController *nav = nil;
    if (self.navigationControllerConstructor) {
        nav = self.navigationControllerConstructor(to);
    }else {
        nav = [[UINavigationController alloc] initWithRootViewController:to];
    }
    
    nav.navigationBar.translucent = NO;
    nav.transitioningDelegate = self;
    nav.modalPresentationStyle = UIModalPresentationCustom;
    [from presentViewController:nav animated:YES completion:^{
        if (completion) {
            completion();
        }
    }];
}

- (void)finishDisplayFromViewController:(UIViewController *)from toViewController:(UIViewController *)to animated:(BOOL)animated completion:(void (^)(void))completion {
    [from dismissViewControllerAnimated:YES completion:^{
        if (completion) {
            completion();
        }
    }];
}

#pragma mark - UIViewControllerTransitioningDelegate
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    _isPresent = YES;
    return self;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    _isPresent = NO;
    return self;
}

#pragma mark - UIViewControllerAnimatedTransitioning
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.33;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    if (_isPresent) {
        [self presentTransition:transitionContext];
    }else {
        [self dismissTransition:transitionContext];
    }
}

- (void)presentTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    
    UIViewController * from = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController * to = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = transitionContext.containerView;
    [containerView addSubview:to.view];
    
    CGRect finalFrame = [transitionContext finalFrameForViewController:to];
    to.view.frame = CGRectOffset(finalFrame, 0, CGRectGetHeight(finalFrame));
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        from.view.transform = CGAffineTransformMakeScale(0.9, 0.9);
        to.view.frame = finalFrame;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
}

- (void)dismissTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    
    UIViewController * from = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController * to = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    CGRect finalFrame = [transitionContext finalFrameForViewController:to];
    to.view.transform = CGAffineTransformMakeScale(0.9, 0.9);
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        from.view.frame = CGRectOffset(finalFrame, 0, CGRectGetHeight(finalFrame));
        to.view.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
}

@end
