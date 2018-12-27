//
//  RARequestHandler.m
//  RouteAction
//
//  Created by GuangYu on 2018/8/26.
//

#import "RARequestHandler.h"
#import "RARequestHandler+Private.h"

@interface RARequestHandler ()
@property (nonatomic, copy) void (^responseCallback)(RAResponse *);
@property (nonatomic, copy) void (^completeCallback)(NSError *error);
@end

@implementation RARequestHandler
- (instancetype)initWithResponse:(void (^)(RAResponse *))response complete:(void (^)(NSError *))complete {
    if (self = [super init]) {
        self.responseCallback = response;
        self.completeCallback = complete;
    }
    return self;
}

- (void (^)(RAResponse *))response {
    return self.responseCallback;
}

- (void (^)(NSError *))complete {
    return self.completeCallback;
}

@end
