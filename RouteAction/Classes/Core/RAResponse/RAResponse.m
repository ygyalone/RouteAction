//
//  RAResponse.m
//  RouteAction
//
//  Created by GuangYu on 2018/8/26.
//

#import "RAResponse.h"

@interface RAResponse()
@property (nonatomic, assign) NSInteger code; ///<响应码
@property (nonatomic, strong) id data;      ///<响应对象
@end

@implementation RAResponse
+ (instancetype)responseWithCode:(NSInteger)code data:(id)data {
    RAResponse *response = [self new];
    response.code = code;
    response.data = data;
    return response;
}

- (NSString *)description {
    return @{@"code":@(_code), @"data":_data?:@""}.description;
}

@end
