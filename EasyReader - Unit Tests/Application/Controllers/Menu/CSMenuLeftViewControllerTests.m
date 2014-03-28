//
//  CSMenuLeftViewControllerTests.m
//  EasyReader
//
//  Created by Alfredo Uribe on 3/28/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "EZRBaseControllerTests.h"
#import "CSMenuLeftViewController.h"

@interface CSMenuLeftViewControllerTests : EZRBaseControllerTests
{
    CSMenuLeftViewController *controller;
}
@end

@implementation CSMenuLeftViewControllerTests

- (void)setUp
{
    [super setUp];
    controller = [[CSMenuLeftViewController alloc] init];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testExample
{
    XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}

@end
