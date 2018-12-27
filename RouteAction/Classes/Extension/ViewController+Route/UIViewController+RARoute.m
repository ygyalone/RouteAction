//
//  UIViewController+RARoute.m
//  RouteAction
//
//  Created by GuangYu on 2018/1/3.
//

#import "UIViewController+RARoute.h"
#import "RARouter.h"
#import "RARequestHandler+Private.h"
#import "RARequest+Private.h"
#import "RATransitionRequest+Private.h"
#import <objc/runtime.h>

@implementation UIViewController (RARoute)

- (instancetype)initWithRARequest:(RATransitionRequest *)request handler:(RARequestHandler *)handler {
    if (self = [self init]) {
        self.ra_sourceRequest = request;
        self.ra_sourceRequestHandler = handler;
    }
    return self;
}

#pragma mark - getter
- (RATransitionRequest *)ra_sourceRequest {
    return objc_getAssociatedObject(self, @selector(ra_sourceRequest));
}

- (RARequestHandler *)ra_sourceRequestHandler {
    return objc_getAssociatedObject(self, @selector(ra_sourceRequestHandler));
}

#pragma mark - setter
- (void)setRa_sourceRequest:(RATransitionRequest *)ra_sourceRequest {
    objc_setAssociatedObject(self, @selector(ra_sourceRequest), ra_sourceRequest, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setRa_sourceRequestHandler:(RARequestHandler *)ra_sourceRequestHandler {
    objc_setAssociatedObject(self, @selector(ra_sourceRequestHandler), ra_sourceRequestHandler, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - display
- (void)ra_startRequest:(RATransitionRequest *)request {
    request.requester = self;
    if(request.url) {
        //url调用
        [[RARouter shared] sendRequest:request];
    }else if(request.targetClass) {
        //class调用
        NSAssert(request.transitionDisplay, @"Error: transition request must has a transitionDisplay!");
        
        RARequestHandler *handler = [[RARequestHandler alloc] initWithResponse:^(RAResponse *response) {
            ra_exeBlock(request.responseCallback, response);
        } complete:^(NSError *error) {
            ra_exeBlock(request.completeCallback, error);
        }];
        
        UIViewController *to = [[request.targetClass alloc] initWithRARequest:request handler:handler];
        to.ra_sourceRequest = request;
        to.ra_sourceRequestHandler = handler;
        
        __weak typeof(request) weak_request = request;
        [request.transitionDisplay displayFromViewController:request.requester
                                            toViewController:to
                                                    animated:request.transitionAnimated
                                                  completion:^{
                                                      ra_exeBlock(weak_request.transitionCompleteCallback, weak_request);
                                                  }];
    }else {
        NSAssert(NO, @"Error: request invalid!");
    }
}

- (void)ra_response:(id)data code:(NSInteger)code {
    if (self.ra_sourceRequestHandler) {
        RATransitionResponse *response = [RATransitionResponse responseWithCode:code data:data responser:self];
        self.ra_sourceRequestHandler.response(response);
    }
}

- (void)ra_complete:(NSError *)error {
    self.ra_sourceRequestHandler.complete(error);
}

#pragma mark - finish display
- (void)ra_finishDisplay {
    [self ra_finishDisplayAnimated:YES completion:nil];
}

- (void)ra_finishDisplayAnimated:(BOOL)animated {
    [self ra_finishDisplayAnimated:animated completion:nil];
}

- (void)ra_finishDisplayAnimated:(BOOL)animated completion:(void(^)(void))completion {
    if(!self.ra_sourceRequest) {
        RALog(@"Error: %@ can not find source request!", self);
        return;
    }
    
    [self.ra_sourceRequest.transitionDisplay finishDisplayFromViewController:self
                                                            toViewController:self.ra_sourceRequest.requester
                                                                    animated:animated
                                                                  completion:completion];
}

@end
