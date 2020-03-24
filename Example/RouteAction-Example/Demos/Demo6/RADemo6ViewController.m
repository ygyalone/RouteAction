//
//  RADemo6ViewController.m
//  RouteAction-Example
//
//  Created by GuangYu on 2018/12/24.
//  Copyright © 2018 GuangYu. All rights reserved.
//

#import "RADemo6ViewController.h"
@import RouteAction;

@interface RADemo6ViewController ()
@property (nonatomic, copy) NSArray<NSDictionary *> *models;
@end

@implementation RADemo6ViewController

+ (void)load {
    [[RARouter shared] registerControllerWithClass:[self class] URLPattern:@"/demo6" constructor:nil];
}

- (NSArray<NSDictionary *> *)models {
    if (!_models) {
        _models = @[@{@"default push":[RAPushTransition new]},
                    @{@"default present":[RAPresentTransition new]}];
    }
    return _models;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"默认转场动画";
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
