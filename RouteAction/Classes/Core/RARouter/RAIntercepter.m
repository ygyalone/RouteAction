//
//  RAIntercepter.m
//  RouteAction
//
//  Created by GuangYu on 2017/12/29.
//

#import "RAIntercepter.h"

@interface RAIntercepter ()
@property (nonatomic, copy) NSString *URLPattern;
@property (nonatomic, copy) void(^awake)(RARequest *request, id<RAIntercepterJudger> judger);
@end

@implementation RAIntercepter

- (instancetype)init {
    NSAssert(NO, @"Error: init method was forbidden!");
    return nil;
}

- (instancetype)initWithAwake:(void(^)(RARequest *request, id<RAIntercepterJudger> judger))awake {
    if (self = [super init]) {
        self.priority = RAIntercepterPriorityNormal;
        self.awake = awake;
    }
    return self;
}

+ (instancetype)intercepterWithAwake:(void(^)(RARequest *request, id<RAIntercepterJudger> judger))awake {
    return [[self alloc] initWithAwake:awake];
}

- (NSComparisonResult)compare:(RAIntercepter *)intercepter {
    if (self.priority < intercepter.priority) {
        return NSOrderedAscending;
    }else if (self.priority > intercepter.priority) {
        return NSOrderedDescending;
    }else {
        return NSOrderedSame;
    }
}

@end
