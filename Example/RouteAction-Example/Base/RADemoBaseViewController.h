//
//  RADemoBaseViewController.h
//  RouteAction-Example
//
//  Created by GuangYu on 2018/12/24.
//  Copyright © 2018 GuangYu. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kCellReuseId    @"kCellReuseId"

@interface UIViewController (RAAlert)
- (void)ra_presentAlertWithTitle:(NSString *)title message:(NSString *)message;
@end

@interface RADemoBaseViewController : UITableViewController

@end
