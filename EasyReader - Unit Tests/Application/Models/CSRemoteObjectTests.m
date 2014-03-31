//
//  CSRemoteObjectTests.m
//  EasyReader
//
//  Created by Alfredo Uribe on 3/28/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "EZRBaseModelTests.h"

// Models
#import "CSRemoteObject.h"

@interface CSRemoteObject (Test)

+ (NSDate *)dateFromAPIDateString:(NSString*)dateString;

@end


@interface CSRemoteObjectTests : EZRBaseModelTests

@end


@implementation CSRemoteObjectTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testDateFromAPIDateStringNilString
{
    XCTAssertTrue([CSRemoteObject dateFromAPIDateString:nil] == nil, @"");
}

- (void)testDateFromAPIDateStringNoTimeString
{
    NSDate *date = [NSDate date];
    
    // First 10 characters go up to the date without time
    NSString *dateString = [[NSString stringWithFormat:@"%@",date] substringWithRange:NSMakeRange(0, 10)];
    
    NSString *resultDateValue = [NSString stringWithFormat:@"%@",[CSRemoteObject dateFromAPIDateString:dateString]];
    
    XCTAssertTrue([resultDateValue rangeOfString:resultDateValue].location == 0, @"");
}

- (void)testDateFromAPIDateStringFullTimeString
{
    NSDate *resultDate = [CSRemoteObject dateFromAPIDateString:@"2014-03-28T14:53:21.000Z"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    
    NSDate *date = [dateFormatter dateFromString:@"2014-03-28T10:53:21.000Z"];
    
    XCTAssertTrue( [resultDate compare:date] == NSOrderedSame, @"");
}


@end
