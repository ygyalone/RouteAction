//
//  RANode.h
//  RouteAction
//
//  Created by GuangYu on 2018/12/14.
//

#import <Foundation/Foundation.h>

@interface RANode<T> : NSObject

@property (nonatomic, readonly) NSString *key;
@property (nonatomic, strong) T value;
@property (nonatomic, readonly) NSUInteger depth;
@property (nonatomic, readonly) RANode *superNode;
@property (nonatomic, readonly) NSDictionary<NSString *, RANode *> *subNodes;

- (instancetype)initWithKey:(nonnull NSString *)key value:(nullable T)value;
- (void)addSubNode:(RANode *)node;
- (void)removeFromSuperNode;

@end
