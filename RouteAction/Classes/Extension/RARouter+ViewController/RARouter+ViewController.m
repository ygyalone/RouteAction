//
//  RARouter+ViewController.m
//  RouteAction
//
//  Created by GuangYu on 2018/1/3.
//

#import "RARouter+ViewController.h"
#import "RATransitionRequest.h"
#import "RATransitionRequest+Private.h"
#import "UIViewController+RARoute.h"

@implementation RARouter (ViewController)

- (void)registerControllerWithClass:(Class)controllerClass
                         URLPattern:(NSString *)URLPattern
                        constructor:(void(^)(UIViewController *vc))constructor {
    NSParameterAssert([controllerClass isSubclassOfClass:UIViewController.class]);
    
    [self registerActionWithURLPattern:URLPattern block:^(RARequest *request, RARequestHandler *handler) {
        NSAssert([request isKindOfClass:[RATransitionRequest class]],
                 @"Error: request:%@ must be kind of RATransitionRequest!", request);
        
        RATransitionRequest *r = (RATransitionRequest *)request;
        NSAssert(r.transitionDisplay, @"Error: transition request must has a transitionDisplay!");
        UIViewController *to = [[controllerClass alloc] initWithRARequest:r handler:handler];
        ra_exeBlock(constructor, to);
        
        __weak typeof(r) weak_r = r;
        [r.transitionDisplay displayFromViewController:r.requester
                                      toViewController:to
                                              animated:r.transitionAnimated
                                            completion:^{
                                                ra_exeBlock(weak_r.transitionCompleteCallback, weak_r);
                                            }];
        
    }];
}

@end

