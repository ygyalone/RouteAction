//
//  RANode+PathParsing.h
//  RouteAction
//
//  Created by GuangYu on 2018/12/15.
//

#import "RANode.h"

@interface NSString (RAPathParsing)
@property (nonatomic, readonly) BOOL ra_isPlaceholder;
@end

@interface RANode (PathParsing)
@property (nonatomic, readonly) BOOL isPlaceholder;
@property (nonatomic, readonly) BOOL containPlaceholder;
@property (nonatomic, readonly) NSString *placeholder;
- (NSArray<RANode *> *)getSubNodesMatchedPath:(NSString *)path;
@end

