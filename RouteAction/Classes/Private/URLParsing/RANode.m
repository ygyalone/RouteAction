//
//  RANode.m
//  RouteAction
//
//  Created by GuangYu on 2018/12/14.
//

#import "RANode.h"

@implementation RANode {
    NSString *_key;
    id _value;
    __weak RANode *_superNode;
    NSMutableDictionary<NSString *, RANode *> *_subNodes;
}

- (instancetype)init {
    NSAssert(NO, @"Error: init method was forbidden!");
    return nil;
}

- (instancetype)initWithKey:(NSString *)key value:(id)value {
    if (self = [super init]) {
        self->_key = key;
        self->_value = value;
        _subNodes = @{}.mutableCopy;
    }
    return self;
}

- (void)addSubNode:(RANode *)node {
    node->_superNode = self;
    _subNodes[node.key] = node;
}

- (NSUInteger)depth {
    NSUInteger depth = 0;
    RANode *superNode = self.superNode;
    while (superNode) {
        depth++;
        superNode = superNode.superNode;
    }
    return depth;
}

- (void)removeFromSuperNode {
    if (self->_superNode) {
        self->_superNode->_subNodes[_key] = nil;
    }
}

- (NSString *)description {
    NSMutableArray *keyPath = @[].mutableCopy;
    
    RANode *node = self;
    [keyPath addObject:node.key];
    while (node.superNode) {
        node = node.superNode;
        [keyPath addObject:node.key];
    }
    
    NSMutableString *str = [NSMutableString string];
    NSUInteger count = keyPath.count - 1;
    for (NSInteger i = count; i>=0; i--) {
        [str appendString:keyPath[i]];
        if (i>0) {
            [str appendString:@"/"];
        }
    }
    
    return str;
}

@end
