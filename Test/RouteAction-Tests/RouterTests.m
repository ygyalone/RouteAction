//
//  RouterTests.m
//  RouteAction-Tests
//
//  Created by GuangYu on 2018/12/26.
//  Copyright © 2018 GuangYu. All rights reserved.
//

#import <XCTest/XCTest.h>
@import RouteAction_Test;

@interface RouterTests : XCTestCase
@property (nonatomic, strong) RARouter *router;
@end

@implementation RouterTests

- (void)setUp {
    _router = [RARouter new];
}

- (void)tearDown {
    _router = nil;
}

- (void)test_action_specific {
    XCTestExpectation *expectation = [[XCTestExpectation alloc] initWithDescription:@"test_response_specific failed!"];
    [self.router registerActionWithURLPattern:@"/a/b/c" block:^(RARequest *request, RARequestHandler *handler) {
        [expectation fulfill];
    }];
    [self.router sendRequest:[RARequest requestWithURL:@"/a/b/c"]];
    [self waitForExpectations:@[expectation] timeout:0.1];
}

- (void)test_action_common {
    XCTestExpectation *expectation = [[XCTestExpectation alloc] initWithDescription:@"test_response_common failed!"];
    [self.router registerActionWithURLPattern:@"/a/*" block:^(RARequest *request, RARequestHandler *handler) {
        [expectation fulfill];
    }];
    [self.router sendRequest:[RARequest requestWithURL:@"/a/b/c"]];
    [self waitForExpectations:@[expectation] timeout:0.1];
}

- (void)test_action_response {
    [self.router registerActionWithURLPattern:@"/a/b/c" block:^(RARequest *request, RARequestHandler *handler) {
        handler.response([RAResponse responseWithCode:123 data:request.params]);
        handler.complete(nil);
    }];
    
    NSDictionary *params = @{@"k1":@"v1"};
    RARequest *request = [RARequest requestWithURL:@"/a/b/c" params:params];
    __block BOOL complete = NO;
    __block RAResponse *response = nil;
    [request onResponse:^(RAResponse *res) {
        response = res;
    }];
    
    [request onComplete:^(NSError *error) {
        complete = !complete;
    }];
    
    [self.router sendRequest:request];
    
    BOOL meet = complete == YES && response.code == 123 && [response.data isEqual:params];
    XCTAssertTrue(meet);
}

- (void)test_intercepter_specific {
    XCTestExpectation *expectation = [[XCTestExpectation alloc] initWithDescription:@"test_intercepter_specific failed!"];
    RAIntercepter *intercepter = [RAIntercepter intercepterWithAwake:^(RARequest *request, id<RAIntercepterJudger> judger) {
        judger.doContinue();
        [expectation fulfill];
    }];
    
    [self.router registerIntercepter:intercepter withURLPattern:@"/a/b/c"];
    [self.router sendRequest:[RARequest requestWithURL:@"/a/b/c"]];
    [self waitForExpectations:@[expectation] timeout:0.1];
}

- (void)test_intercepter_common {
    XCTestExpectation *expectation = [[XCTestExpectation alloc] initWithDescription:@"test_intercepter_common failed!"];
    RAIntercepter *intercepter = [RAIntercepter intercepterWithAwake:^(RARequest *request, id<RAIntercepterJudger> judger) {
        judger.doContinue();
        [expectation fulfill];
    }];
    
    [self.router registerIntercepter:intercepter withURLPattern:@"/a/b/*"];
    [self.router sendRequest:[RARequest requestWithURL:@"/a/b/c"]];
    [self waitForExpectations:@[expectation] timeout:0.1];
}

- (void)test_intercepter_priority {
    NSMutableArray *result = [NSMutableArray array];
    RAIntercepter *intercepter1 = [RAIntercepter intercepterWithAwake:^(RARequest *request, id<RAIntercepterJudger> judger) {
        judger.doContinue();
        [result addObject:@"1"];
    }];
    
    RAIntercepter *intercepter2 = [RAIntercepter intercepterWithAwake:^(RARequest *request, id<RAIntercepterJudger> judger) {
        judger.doContinue();
        [result addObject:@"2"];
    }];
    
    RAIntercepter *intercepter3 = [RAIntercepter intercepterWithAwake:^(RARequest *request, id<RAIntercepterJudger> judger) {
        judger.doContinue();
        [result addObject:@"3"];
    }];
    
    intercepter1.priority = RAIntercepterPriorityNormal;
    intercepter2.priority = RAIntercepterPriorityLow;
    intercepter3.priority = RAIntercepterPriorityHigh;
    
    [self.router registerIntercepter:intercepter1 withURLPattern:@"/a/b/c"];
    [self.router registerIntercepter:intercepter2 withURLPattern:@"/a/b/c"];
    [self.router registerIntercepter:intercepter3 withURLPattern:@"/a/b/c"];
    [self.router sendRequest:[RARequest requestWithURL:@"/a/b/c"]];
    
    BOOL equal = [result isEqual:@[@"3",@"1",@"2"]];
    XCTAssert(equal);
}

- (void)test_deregister_action {
    __block BOOL actived = NO;
    [self.router registerActionWithURLPattern:@"/a/b/c" block:^(RARequest *request, RARequestHandler *handler) {
        actived = YES;
    }];
    [self.router deregisterWithURLPattern:@"/a/b/c"];
    [self.router sendRequest:[RARequest requestWithURL:@"/a/b/c"]];
    XCTAssertFalse(actived);
}

- (void)test_deregister_intercepter {
    __block BOOL actived = NO;
    RAIntercepter *intercepter = [RAIntercepter intercepterWithAwake:^(RARequest *request, id<RAIntercepterJudger> judger) {
        actived = YES;
        judger.doContinue();
    }];
    [self.router registerIntercepter:intercepter withURLPattern:@"/a/b/*"];
    [self.router deregisterWithURLPattern:@"/a/b"];
    [self.router sendRequest:[RARequest requestWithURL:@"/a/b/c"]];
    XCTAssertFalse(actived);
}

- (void)test_deregister_common {
    __block BOOL actived = NO;
    [self.router registerActionWithURLPattern:@"/a/b/c" block:^(RARequest *request, RARequestHandler *handler) {
        actived = YES;
    }];
    [self.router deregisterWithURLPattern:@"/a/*"];
    [self.router sendRequest:[RARequest requestWithURL:@"/a/b/c"]];
    XCTAssertFalse(actived);
}

@end
