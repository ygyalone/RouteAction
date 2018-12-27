//
//  TreeTests.m
//  RouteActionTests
//
//  Created by GuangYu on 2018/12/21.
//  Copyright © 2018 GuangYu. All rights reserved.
//

#import <XCTest/XCTest.h>
@import RouteAction_Test;

@interface TreeTests : XCTestCase
@property (nonatomic, strong) RATree *tree;
@end

@implementation TreeTests

- (void)setUp {
    _tree = [RATree new];
}

- (void)tearDown {
    _tree = nil;
}

#pragma mark - insert
- (void)test_insert {
    NSArray *paths = [self pathsOfUrl:@"/a/b/c"];
    RANode *node = [self.tree insertNodeByPaths:paths];
    XCTAssertEqualObjects(node.description, @"/a/b/c");
}

#pragma mark - search
- (void)test_search_found {
    NSArray *paths = [self pathsOfUrl:@"/a/b/c"];
    [self.tree insertNodeByPaths:paths];
    RANode *node = [self.tree searchNodeByPaths:paths];
    XCTAssertEqualObjects(node.description, @"/a/b/c");
}

- (void)test_search_notFount {
    NSArray *paths1 = [self pathsOfUrl:@"/a/b/c"];
    NSArray *paths2 = [self pathsOfUrl:@"/d/b/c"];
    [self.tree insertNodeByPaths:paths1];
    RANode *node = [self.tree searchNodeByPaths:paths2];
    XCTAssertEqualObjects(node.description, @"");
}

- (void)test_search_nearest {
    NSArray *paths1 = [self pathsOfUrl:@"/a/b/c"];
    NSArray *paths2 = [self pathsOfUrl:@"/a/b/d/e/f"];
    [self.tree insertNodeByPaths:paths1];
    RANode *node = [self.tree searchNodeByPaths:paths2];
    XCTAssertEqualObjects(node.description, @"/a/b");
}

- (void)test_search_placeholder {
    NSArray *paths1 = [self pathsOfUrl:@"/a/:id/c"];
    NSArray *paths2 = [self pathsOfUrl:@"/a/12/c"];
    [self.tree insertNodeByPaths:paths1];
    RANode *node = [self.tree searchNodeByPaths:paths2];
    XCTAssertEqualObjects(node.description, @"/a/:id/c");
}

- (void)test_search_placeholder_priority {
    NSArray *paths1 = [self pathsOfUrl:@"/a/:id/c"];
    NSArray *paths2 = [self pathsOfUrl:@"/a/12/c"];
    [self.tree insertNodeByPaths:paths1];
    [self.tree insertNodeByPaths:paths2];
    RANode *node = [self.tree searchNodeByPaths:paths2];
    XCTAssertEqualObjects(node.description, @"/a/12/c");
}

- (void)test_search_placeholder_depth {
    NSArray *paths1 = [self pathsOfUrl:@"/a/:id/c/d"];
    NSArray *paths2 = [self pathsOfUrl:@"/a/12/c"];
    NSArray *paths3 = [self pathsOfUrl:@"/a/12/c/d"];
    [self.tree insertNodeByPaths:paths1];
    [self.tree insertNodeByPaths:paths2];
    RANode *node = [self.tree searchNodeByPaths:paths3];
    XCTAssertEqualObjects(node.description, @"/a/:id/c/d");
}

#pragma mark - remove
- (void)test_remove_exist {
    NSArray *paths = [self pathsOfUrl:@"/a/b/c"];
    [self.tree insertNodeByPaths:paths];
    BOOL result = [self.tree removeNodeByPaths:paths forced:NO];
    RANode *node = [self.tree searchNodeByPaths:paths];
    XCTAssert(result && node.depth == 0);
}

- (void)test_remove_notExist1 {
    NSArray *paths = [self pathsOfUrl:@"/a/b/c"];
    BOOL result = [self.tree removeNodeByPaths:paths forced:NO];
    XCTAssertFalse(result);
}

- (void)test_remove_notExist2 {
    NSArray *paths1 = [self pathsOfUrl:@"/a/b/c"];
    NSArray *paths2 = [self pathsOfUrl:@"/a/b/d"];
    [self.tree insertNodeByPaths:paths1];
    BOOL result = [self.tree removeNodeByPaths:paths2 forced:NO];
    RANode *node = [self.tree searchNodeByPaths:paths1];
    XCTAssert(!result && [node.description isEqualToString:@"/a/b/c"]);
}

- (void)test_remove_force {
    NSArray *paths1 = [self pathsOfUrl:@"/a/b/c"];
    NSArray *paths2 = [self pathsOfUrl:@"/a/b/d"];
    NSArray *paths3 = [self pathsOfUrl:@"/a/b"];
    [self.tree insertNodeByPaths:paths1];
    [self.tree insertNodeByPaths:paths2];
    [self.tree removeNodeByPaths:paths3 forced:YES];
    RANode *node1 = [self.tree searchNodeByPaths:paths1];
    RANode *node2 = [self.tree searchNodeByPaths:paths2];
    XCTAssert(!node1.depth && !node2.depth);
}

- (void)test_remove_notForce {
    NSArray *paths1 = [self pathsOfUrl:@"/a/b/c"];
    NSArray *paths2 = [self pathsOfUrl:@"/a/b/d"];
    NSArray *paths3 = [self pathsOfUrl:@"/a/b"];
    [self.tree insertNodeByPaths:paths1];
    [self.tree insertNodeByPaths:paths2];
    [self.tree removeNodeByPaths:paths3 forced:NO];
    RANode *node1 = [self.tree searchNodeByPaths:paths1];
    RANode *node2 = [self.tree searchNodeByPaths:paths2];
    BOOL r1 = [node1.description isEqualToString:@"/a/b/c"];
    BOOL r2 = [node2.description isEqualToString:@"/a/b/d"];
    XCTAssert(r2&&r1);
}

#pragma mark - util
- (nullable NSArray<NSString *> *)pathsOfUrl:(NSString *)URLString {
    return [NSURL URLWithString:URLString].ra_pathsOfPattern;
}

@end
