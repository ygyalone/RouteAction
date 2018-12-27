//
//  CustomPushTransition.m
//  RouteAction_Example
//
//  Created by GuangYu on 2018/2/27.
//  Copyright © 2018年 ygyalone. All rights reserved.
//

#import "CustomPushTransition.h"

@interface CustomPushTransition () <UIViewControllerAnimatedTransitioning, UINavigationControllerDelegate>
@property (nonatomic, copy) void(^displayCompletion)(void);
@property (nonatomic, copy) void(^finishDisplayCompletion)(void);
@property (nonatomic, assign) UINavigationControllerOperation operation;
@property (nonatomic, weak) UINavigationController *navigationController;
@property (nonatomic, weak) id<UINavigationControllerDelegate> lastDelegate;
@end

@implementation CustomPushTransition

- (instancetype)init {
    if (self = [super init]) {
        _operation = UINavigationControllerOperationNone;
    }
    return self;
}

#pragma mark - RATransitionDisplay
- (void)displayFromViewController:(UIViewController *)from toViewController:(UIViewController *)to animated:(BOOL)animated completion:(void (^)(void))completion {
    
    self.navigationController = from.navigationController;
    self.lastDelegate = self.navigationController.delegate;
    self.navigationController.delegate = self;
    
    __weak typeof(self) weak_self = self;
    [self setDisplayCompletion:^{
        weak_self.navigationController.delegate = weak_self.lastDelegate;
        weak_self.lastDelegate = nil;
        if (completion) { completion(); }
    }];
    
    [from.navigationController pushViewController:to animated:YES];
}

- (void)finishDisplayFromViewController:(UIViewController *)from toViewController:(UIViewController *)to animated:(BOOL)animated completion:(void (^)(void))completion {
    
    self.navigationController = from.navigationController;
    self.lastDelegate = self.navigationController.delegate;
    self.navigationController.delegate = self;
    
    __weak typeof(self) weak_self = self;
    [self setFinishDisplayCompletion:^{
        weak_self.navigationController.delegate = weak_self.lastDelegate;
        weak_self.lastDelegate = nil;
        if (completion) { completion(); }
    }];
    
    [from.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIViewControllerAnimatedTransitioning
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.33;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    UIViewController * to = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    to.view.alpha = 0;
    
    UIView * containerView = transitionContext.containerView;
    [containerView addSubview:to.view];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        to.view.alpha = 1;
    } completion:^(BOOL finished) {
        
        [transitionContext completeTransition:YES];
        
        if (self.operation == UINavigationControllerOperationPush && self.displayCompletion) {
            self.displayCompletion();
        }else if (self.operation == UINavigationControllerOperationPop && self.finishDisplayCompletion) {
            self.finishDisplayCompletion();
        }
    }];
}

#pragma mark - UINavigationControllerDelegate
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC{
    self.operation = operation;
    if (operation == UINavigationControllerOperationPush){
        return self;
    }else{
        return self;
    }
}

@end
