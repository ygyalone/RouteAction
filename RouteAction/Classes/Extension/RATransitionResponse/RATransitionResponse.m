//
//  RATransitionResponse.m
//  RouteAction
//
//  Created by GuangYu on 2018/8/26.
//

#import "RATransitionResponse.h"
@interface RATransitionResponse()
@property (nonatomic, weak) UIViewController *responser;
@end

@implementation RATransitionResponse

+ (instancetype)responseWithCode:(NSInteger)code data:(id)data responser:(UIViewController *)responser {
    RATransitionResponse *response = [self responseWithCode:code data:data];
    response.responser = responser;
    return response;
}

- (NSString *)description {
    return @{@"code":@(self.code), @"data":self.data?:@"", @"responser":_responser?:@""}.description;
}

@end
