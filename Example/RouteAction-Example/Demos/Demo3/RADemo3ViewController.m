//
//  RADemo3ViewController.m
//  RouteAction-Example
//
//  Created by GuangYu on 2018/12/24.
//  Copyright © 2018 GuangYu. All rights reserved.
//

#import "RADemo3ViewController.h"
@import RouteAction;

@implementation RADemo3ViewController

+ (void)load {
    [[RARouter shared] registerControllerWithClass:[self class] URLPattern:@"/demo3/:account/:password"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"路径参数";
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self ra_presentAlertWithTitle:@"收到请求" message:self.ra_sourceRequest.description];
}

@end
