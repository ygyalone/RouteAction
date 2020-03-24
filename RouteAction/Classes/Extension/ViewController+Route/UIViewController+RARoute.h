//
//  UIViewController+RARoute.h
//  RouteAction
//
//  Created by GuangYu on 2018/1/3.
//

#import <UIKit/UIKit.h>
#import "RARequestHandler.h"
#import "RATransitionRequest.h"
#import "RATransitionResponse.h"

@interface UIViewController (RARoute)

- (instancetype)initWithRARequest:(RATransitionRequest *)request handler:(RARequestHandler<RATransitionResponse *> *)handler;
@property (nonatomic, readonly) RATransitionRequest *ra_sourceRequest;
@property (nonatomic, readonly) RARequestHandler<RATransitionResponse *> *ra_sourceRequestHandler;

- (void)ra_startRequest:(RATransitionRequest *)request;
- (void)ra_response:(id)data code:(NSInteger)code;
- (void)ra_complete:(NSError *)error;
- (void)ra_finishDisplay;
- (void)ra_finishDisplayAnimated:(BOOL)animated;
- (void)ra_finishDisplayAnimated:(BOOL)animated completion:(void(^)(void))completion;

@end
