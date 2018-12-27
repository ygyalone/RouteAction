//
//  RADemo1ViewController.m
//  RouteAction-Example
//
//  Created by GuangYu on 2018/12/24.
//  Copyright © 2018 GuangYu. All rights reserved.
//

#import "RADemo1ViewController.h"
@import RouteAction;

@implementation RADemo1ViewController

+ (void)load {
    //注册控制器
    [[RARouter shared] registerControllerWithClass:[self class] URLPattern:@"/demo1"];
    //注册事件
    [[RARouter shared] registerActionWithURLPattern:@"/demo1/action" block:^(RARequest *request, RARequestHandler *handler) {
        UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
        [rootViewController ra_presentAlertWithTitle:@"收到请求" message:request.description];
        RAResponse *response = [RAResponse responseWithCode:0 data:@{@"k":@"v"}];
        handler.response(response);
        handler.complete(nil);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"路由事件";
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self sendRequest];
}

- (void)sendRequest {
    RARequest *request = [RARequest requestWithURL:@"/demo1/action?user=ygy&&password=123" params:@{@"k":@"v"}];
    
    [request onResponse:^(RAResponse *response) {
        NSLog(@"收到响应:%@", response);
    }];
    
    [request onComplete:^(NSError *error) {
        NSLog(@"请求完成:%@", error);
    }];
    
    [[RARouter shared] sendRequest:request];
}

@end
