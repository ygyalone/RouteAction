//
//  NSURL+RAPathParsing.h
//  RouteAction
//
//  Created by GuangYu on 2018/12/25.
//

#import <Foundation/Foundation.h>

@interface NSURL (RAPathParsing)
@property (nonatomic, readonly) BOOL ra_isValidPattern;///<URL模板是否合法
@property (nonatomic, readonly) BOOL ra_isCommonPattern;///<URL是否是通配模板
@property (nonatomic, readonly) NSArray<NSString *> *ra_pathsOfRequest;///<请求URL的路径
@property (nonatomic, readonly) NSArray<NSString *> *ra_pathsOfPattern;///<模板URL的路径
@end
