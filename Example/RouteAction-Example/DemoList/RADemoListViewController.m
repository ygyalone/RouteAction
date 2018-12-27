//
//  ViewController.m
//  RouteAction-Example
//
//  Created by GuangYu on 2018/12/21.
//  Copyright © 2018 GuangYu. All rights reserved.
//

#import "RADemoListViewController.h"
@import RouteAction;
#define kCellResuseId   @"kCellResuseId"

@interface RADemoListViewController ()
@property (nonatomic, copy) NSArray<NSDictionary *> *demos;
@end

@implementation RADemoListViewController

- (NSArray<NSDictionary *> *)demos {
    if (!_demos) {
        _demos = @[@{@"1.路由事件":@"/demo1"},
                   @{@"2.拦截器":@"/demo2"},
                   @{@"3.路径参数":@"/demo3/zhangsan/123456"},
                   @{@"4.404":@"/demo4"},
                   @{@"5.控制器跳转":@"/demo5"},
                   @{@"6.默认转场动画":@"/demo6"},
                   @{@"7.自定义转场动画":@"/demo7"}];
    }
    return _demos;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Demo List";
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellResuseId];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.view.backgroundColor = [UIColor whiteColor];
}

#pragma mark - data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.demos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellResuseId forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = self.demos[indexPath.row].allKeys[0];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    return cell;
}

#pragma mark - delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *url = self.demos[indexPath.row].allValues[0];
    RATransitionRequest *request = [RATransitionRequest pushTransitionRequestWithURL:url];
    [self ra_startRequest:request];
}

@end
