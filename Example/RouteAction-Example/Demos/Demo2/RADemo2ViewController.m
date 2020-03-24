//
//  RADemo2ViewController.m
//  RouteAction-Example
//
//  Created by GuangYu on 2018/12/24.
//  Copyright © 2018 GuangYu. All rights reserved.
//

#import "RADemo2ViewController.h"
@import RouteAction;

@implementation RADemo2ViewController

+ (void)load {
    //注册控制器
    [[RARouter shared] registerControllerWithClass:[self class] URLPattern:@"/demo2" constructor:nil];
    //注册拦截器
    RAIntercepter *intercepter = [RAIntercepter intercepterWithAwake:^(RARequest *request, id<RAIntercepterJudger> judger) {
        judger.doContinue();
        UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
        [rootViewController ra_presentAlertWithTitle:@"拦截到请求" message:request.description];
    }];
    [[RARouter shared] registerIntercepter:intercepter withURLPattern:@"/demo2/*"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"拦截器";
}

@end
