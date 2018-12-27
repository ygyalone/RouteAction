//
//  RAPresentTransition.h
//  RouteAction
//
//  Created by GuangYu on 2018/2/2.
//

#import <Foundation/Foundation.h>
#import "RATransitionDisplay.h"

@interface RAPresentTransition : NSObject <RATransitionDisplay>
@property (nonatomic, copy) UINavigationController *(^navigationControllerConstructor)(UIViewController *root);
@end
