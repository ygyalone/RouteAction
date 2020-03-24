//
//  RARouter+ViewController.h
//  RouteAction
//
//  Created by GuangYu on 2018/1/3.
//

#import "RARouter.h"

@interface RARouter (ViewController)

- (void)registerControllerWithClass:(Class)controllerClass
                         URLPattern:(NSString *)URLPattern
                        constructor:(void(^)(UIViewController *vc))constructor;

@end
