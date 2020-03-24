//
//  RADemo4ViewController.m
//  RouteAction-Example
//
//  Created by GuangYu on 2018/12/24.
//  Copyright © 2018 GuangYu. All rights reserved.
//

#import "RADemo4ViewController.h"
@import RouteAction;

@implementation RADemo4ViewController

+ (void)load {
    [[RARouter shared] registerControllerWithClass:[self class] URLPattern:@"/demo4" constructor:nil];
    
    [[RARouter shared] configGlobalMissmatch:^(RARequest * _Nonnull request) {
        UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
        [rootViewController ra_presentAlertWithTitle:@"404" message:request.description];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"404";
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    RARequest *request = [RARequest requestWithURL:@"/askdljqwkeqwe/asdkjqwklejqe?asd=123213&&qq=123123"];
    [[RARouter shared] sendRequest:request];
}

@end
