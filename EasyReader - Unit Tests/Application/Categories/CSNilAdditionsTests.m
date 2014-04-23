//
//  CSNilAdditionsTests.m
//  EasyReader
//
//  Created by Alfredo Uribe on 4/17/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "EZRBaseCategoryTests.h"
#import "NSObject+CSNilAdditions.h"

@interface CSNilAdditionsTests : EZRBaseCategoryTests
{
    NSObject *object;
}
@end

@implementation CSNilAdditionsTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testIsBlankWithSet
{
    NSSet *toTest = [NSSet setWithArray:@[]];
    XCTAssertTrue([toTest isBlank], @"");
}

- (void)testIsBlankWithArray
{
    XCTAssertTrue([@[] isBlank], @"");
}

- (void)testIsBlankWithEmptyString
{
    XCTAssertTrue([@"" isBlank], @"");
}

- (void)testIsBlankWithNull
{
    XCTAssertTrue([[NSNull null] isBlank], @"");
}

@end
