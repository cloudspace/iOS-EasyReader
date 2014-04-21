//
//  EZRSortingAdditionsTests.m
//  EasyReader
//
//  Created by Alfredo Uribe on 4/17/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "EZRBaseCategoryTests.h"
#import "NSSet+CSSortingAdditions.h"

@interface EZRSortingAdditionsTests : EZRBaseCategoryTests

@end

@implementation EZRSortingAdditionsTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testSortedArrayByAttributes
{
    NSArray *data = @[
                      @{@"name" : @"b"},
                      @{@"name" : @"a"},
                      @{@"name" : @"c"}
                      ];
    NSSet *toSort = [NSSet setWithArray:data];
    
    NSArray *sorted = @[
                        @{@"name" : @"a"},
                        @{@"name" : @"b"},
                        @{@"name" : @"c"}
                        ];
    
    BOOL assert = [[toSort sortedArrayByAttributes:@[@"name"] ascending:YES] isEqualToArray:sorted];
    XCTAssertTrue(assert, @"");
}

//- (void)testSortedArrayByTwoAttributes
//{
//    NSArray *data = @[
//                      @{ @"first" : @"b", @"second" : @"b" },
//                      @{ @"first" : @"c", @"second" : @"a" },
//                      @{ @"first" : @"a", @"second" : @"b" },
//                      @{ @"first" : @"a", @"second" : @"a" },
//                      @{ @"first" : @"b", @"second" : @"a" },
//                      @{ @"first" : @"c", @"second" : @"b" }
//                      ];
//    NSSet *toSort = [NSSet setWithArray:data];
//    
//    NSArray *sorted = @[
//                        @{ @"first" : @"a", @"second" : @"a" },
//                        @{ @"first" : @"a", @"second" : @"b" },
//                        @{ @"first" : @"b", @"second" : @"a" },
//                        @{ @"first" : @"b", @"second" : @"b" },
//                        @{ @"first" : @"c", @"second" : @"a" },
//                        @{ @"first" : @"c", @"second" : @"b" }
//                        ];
//    
//    BOOL assert = [[toSort sortedArrayByAttributes:@[@"name",@"second"] ascending:YES] isEqualToArray:sorted];
//    XCTAssertTrue(assert, @"");
//}

@end
