//
//  RADemo5ViewController.m
//  RouteAction-Example
//
//  Created by GuangYu on 2018/12/24.
//  Copyright © 2018 GuangYu. All rights reserved.
//

#import "RADemo5ViewController.h"
@import RouteAction;

@implementation RADemo5ViewController

+ (void)load {
    [[RARouter shared] registerControllerWithClass:[self class] URLPattern:@"/demo5" constructor:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"控制器跳转";
}

#pragma mark - data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellReuseId forIndexPath:indexPath];
    cell.textLabel.text = @"present: /demo5";
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

#pragma mark - delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self ra_startRequest:[RATransitionRequest presentTransitionRequestWithURL:@"/demo5"]];
}

@end
