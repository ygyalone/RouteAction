//
//  NSURL+RAPathParsing.m
//  RouteAction
//
//  Created by GuangYu on 2018/12/25.
//

#import "NSURL+RAPathParsing.h"

@implementation NSURL (RAPathParsing)

- (BOOL)ra_isValidPattern {
    //模板只能包含path
    if (self.scheme.length ||
        self.host.length ||
        self.query.length ||
        self.fragment.length ||
        self.user.length ||
        self.password.length) {
        return NO;
    }
    
    return self.path.length > 0;
}

- (BOOL)ra_isCommonPattern {
    return self.ra_isValidPattern && [self.absoluteString hasSuffix:@"/*"];
}

- (NSArray<NSString *> *)ra_pathsOfPattern {
    if (!self.ra_isValidPattern) {
        return nil;
    }
    
    NSMutableArray *paths = self.pathComponents.mutableCopy;
    
    if ([paths.firstObject isEqualToString:@"/"]) {
        [paths removeObjectAtIndex:0];
    }
    
    if ([paths.lastObject isEqualToString:@"*"]) {
        [paths removeLastObject];
    }
    
    return paths;
}

- (NSArray<NSString *> *)ra_pathsOfRequest {
    NSMutableArray *paths = self.pathComponents.mutableCopy;
    
    if ([paths.firstObject isEqualToString:@"/"]) {
        [paths removeObjectAtIndex:0];
    }
    
    return paths;
}

@end
