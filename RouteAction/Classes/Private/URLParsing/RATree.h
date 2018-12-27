//
//  RATree.h
//  RouteAction
//
//  Created by GuangYu on 2018/12/14.
//

#import <Foundation/Foundation.h>
#import "RANode+PathParsing.h"

NS_ASSUME_NONNULL_BEGIN

/**
 数据模型，用来表示URL路径的层级结构
 */
@interface RATree<T> : NSObject

@property (nonatomic, readonly) RANode *root;

- (nullable RANode<T> *)insertNodeByPaths:(NSArray<NSString *> *)paths;
- (BOOL)removeNodeByPaths:(NSArray<NSString *> *)paths forced:(BOOL)forced;
- (RANode<T> *)searchNodeByPaths:(NSArray<NSString *> *)paths;

@end

NS_ASSUME_NONNULL_END
