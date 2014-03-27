//
//  EZRBaseModelTests.m
//  EasyReader
//
//  Created by Alfredo Uribe on 3/27/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import "EZRBaseModelTests.h"
#import "APIClient.h"

@implementation EZRBaseModelTests

- (void)setUp
{
    mockAPIClient = [OCMockObject mockForClass:[APIClient class]];
    mockObserver  = [OCMockObject observerMock];
    
    [APIClient setSharedClient:mockAPIClient];
}


- (void)tearDown
{
    [super tearDown];
}

@end
