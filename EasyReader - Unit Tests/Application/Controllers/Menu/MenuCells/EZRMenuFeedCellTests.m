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
#import "EZRMenuFeedCell.h"


@interface EZRMenuFeedCellTests : EZRBaseControllerTests
{
    EZRMenuFeedCell *cell;
}
@end


@implementation EZRMenuFeedCellTests

- (void)setUp
{
    cell = [[EZRMenuFeedCell alloc] init];
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}


@end
