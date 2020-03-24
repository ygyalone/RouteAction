//
//  RADemo7ViewController.m
//  RouteAction-Example
//
//  Created by GuangYu on 2018/12/24.
//  Copyright © 2018 GuangYu. All rights reserved.
//

#import "RADemo7ViewController.h"
#import "CustomPushTransition.h"
#import "CustomPresentTransition.h"
@import RouteAction;

@interface RADemo7ViewController ()
@property (nonatomic, copy) NSArray<NSDictionary *> *models;
@end

@implementation RADemo7ViewController

+ (void)load {
    [[RARouter shared] registerControllerWithClass:[self class] URLPattern:@"/demo7" constructor:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"自定义转场动画";
}

- (NSArray<NSDictionary *> *)models {
    if (!_models) {
        _models = @[@{@"custom push":[CustomPushTransition new]},
                    @{@"custom present":[CustomPresentTransition new]}];
    }
    return _models;
}

#pragma mark - data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellReuseId forIndexPath:indexPath];
    cell.textLabel.text = self.models[indexPath.row].allKeys[0];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    return cell;
}

#pragma mark - delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    RATransitionRequest *request = [RATransitionRequest requestWithURL:@"/demo6"];
    request.transitionDisplay = self.models[indexPath.row].allValues[0];
    [self ra_startRequest:request];
}

@end
