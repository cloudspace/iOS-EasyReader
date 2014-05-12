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
#import "APIRemoteObject.h"

@interface APIRemoteObject (Test)

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
    
    NSString *resultDateValue = [NSString stringWithFormat:@"%@",[APIRemoteObject dateFromAPIDateString:dateString]];
    
    XCTAssertTrue([resultDateValue rangeOfString:resultDateValue].location == 0, @"");
}

- (void)testDateFromAPIDateStringFullTimeString
{
    NSString *dateString = @"2014-03-28T14:53:21.000Z";
    NSDate *resultDate = [APIRemoteObject dateFromAPIDateString:dateString];
    
    NSLog(@"%@", resultDate);
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    NSDate *date = [dateFormatter dateFromString:@"2014-03-28T14:53:21.000Z"];
    
    NSLog(@"%@", date);
    XCTAssertTrue([resultDate isEqualToDate:date], @"");
}


@end
