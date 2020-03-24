//
//  RAResponse.h
//  RouteAction
//
//  Created by GuangYu on 2018/8/26.
//

#import <Foundation/Foundation.h>

@interface RAResponse : NSObject

@property (nonatomic, readonly) NSInteger code; ///<响应码

@property (nonatomic, readonly) id data;        ///<响应数据

+ (instancetype)responseWithCode:(NSInteger)code data:(id)data;

@end
