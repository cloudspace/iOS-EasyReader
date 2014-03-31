//
//  EZRCustomFeedCellTests.m
//  EasyReader
//
//  Created by Alfredo Uribe on 3/28/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "EZRBaseControllerTests.h"

// Models
#import "EZRCustomFeedCell.h"

@interface EZRCustomFeedCell (Test)

- (BOOL)isValidUrl:(NSString *)url;

@end


@interface EZRCustomFeedCellTests : EZRBaseControllerTests
{
    EZRCustomFeedCell *cell;
}
@end


@implementation EZRCustomFeedCellTests

- (void)setUp
{
    cell = [[EZRCustomFeedCell alloc] init];
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testIsValidUrlEndsWithDot
{
    XCTAssertTrue([cell isValidUrl:@"somethingFollowedByADot."],@"");
}

- (void)testIsValidUrlNotEndingWithDot
{
    XCTAssertFalse([cell isValidUrl:@"prettyMuchAnythingElse"],@"");
}

@end
