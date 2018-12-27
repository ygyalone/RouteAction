//
//  RATree.m
//  RouteAction
//
//  Created by GuangYu on 2018/12/14.
//

#import "RATree.h"

@implementation RATree {
    RANode *_root;
}

- (instancetype)init {
    if (self = [super init]) {
        _root = [[RANode alloc] initWithKey:@"" value:nil];
    }
    return self;
}

- (RANode *)root {
    return _root;
}

- (RANode *)insertNodeByPaths:(NSArray<NSString *> *)paths {
    if (!paths) { return nil; }
    if (!paths.count) { return _root; }
    
    RANode *superNode = _root;
    RANode *node = nil;
    
    for (NSString *path in paths) {
        
        //同一层级只能有一个占位节点
        if (path.ra_isPlaceholder && superNode.containPlaceholder && !superNode.subNodes[path]) {
            NSAssert(NO, @"Already has a placeholder node, can not insert another one!");
            return nil;
        }
        
        node = superNode.subNodes[path];
        if (!node) {
            node = [[RANode alloc] initWithKey:path value:nil];
            @synchronized (self) {
                [superNode addSubNode:node];
            }
        }
        
        superNode = node;
    }
    
    return node;
}

- (BOOL)removeNodeByPaths:(NSArray<NSString *> *)paths forced:(BOOL)forced {
    RANode *superNode = _root;
    RANode *node = nil;
    
    for (NSString *path in paths) {
        node = superNode.subNodes[path];
        if (!node) {
            break;
        }
        superNode = node;
    }
    
    if (node) {
        [self removeNode:node forced:forced];
    }
    
    return node!=nil;
}

- (void)removeNode:(RANode *)node forced:(BOOL)forced {
    if (node.subNodes.count > 0 && !forced) {
        node.value = nil;
        return;
    }
    
    RANode *keyNode = node;
    while (keyNode.superNode &&
           keyNode.superNode != _root &&
           keyNode.superNode.subNodes.allValues.count == 1) {
        keyNode = keyNode.superNode;
    }
    
    @synchronized (self) {
        [keyNode removeFromSuperNode];
    }
}

- (RANode *)searchNodeByPaths:(NSArray<NSString *> *)paths {
    return [self searchDeepestNodeWithMatchPlaceholder:paths root:_root]?:_root;
}

- (RANode *)searchDeepestNodeWithMatchPlaceholder:(NSArray<NSString *> *)paths root:(RANode *)root {
    RANode *deeperNode = nil;
    NSString *path = paths.firstObject;
    
    if (!path.length) {
        return deeperNode;
    }
    
    NSArray<RANode *> *matchedNodes = [root getSubNodesMatchedPath:path];
    if (!matchedNodes.count) {
        return deeperNode;
    }
    
    deeperNode = matchedNodes.firstObject;
    for (RANode *node in matchedNodes) {
        NSArray *subPaths = [paths subarrayWithRange:NSMakeRange(1, paths.count-1)];
        RANode *result = [self searchDeepestNodeWithMatchPlaceholder:subPaths root:node];
        if (result.depth > deeperNode.depth) {
            deeperNode = result;
        }
    }
    
    return deeperNode;
}

@end
