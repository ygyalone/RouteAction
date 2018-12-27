//
//  RANode+PathParsing.m
//  RouteAction
//
//  Created by GuangYu on 2018/12/15.
//

#import "RANode+PathParsing.h"

#pragma mark - NSString (RAPathParsing)
@implementation NSString (RAPathParsing)

- (BOOL)ra_isPlaceholder {
    return [self hasPrefix:@":"];
}

@end

#pragma mark - RANode (PathParsing)
@implementation RANode (PathParsing)

- (BOOL)isPlaceholder {
    return self.key.ra_isPlaceholder;
}

- (BOOL)containPlaceholder {
    for (RANode *subNode in self.subNodes.allValues) {
        if (subNode.isPlaceholder) {
            return YES;
        }
    }
    return NO;
}

- (NSString *)placeholder {
    if (!self.isPlaceholder) {
        return nil;
    }
    return [self.key substringFromIndex:1];
}

- (NSArray<RANode *> *)getSubNodesMatchedPath:(NSString *)path {
    NSMutableArray *nodes = @[].mutableCopy;
    
    RANode *specificNode = self.subNodes[path];
    RANode *placeholderNode = nil;
    
    for (RANode *subNode in self.subNodes.allValues) {
        if (subNode.isPlaceholder) {
            placeholderNode = subNode;
        }
    }
    
    if (specificNode) {
        [nodes addObject:specificNode];
    }
    
    if (placeholderNode) {
        [nodes addObject:placeholderNode];
    }
    
    return nodes;
}

@end
