//
//  EZRBaseCategoryTests.m
//  EasyReader
//
//  Created by Alfredo Uribe on 4/17/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import "EZRBaseCategoryTests.h"
#import "APIClient.h"

@implementation EZRBaseCategoryTests

- (void)setUp
{
    mockAPIClient = [OCMockObject mockForClass:[APIClient class]];
    mockObserver  = [OCMockObject observerMock];
    
    [APIClient setSharedClient:mockAPIClient];
    
    // Set up core data
    [MagicalRecord setupCoreDataStackWithInMemoryStore];
}


- (void)tearDown
{
    // Clean up core data
    [MagicalRecord cleanUp];
    
    [super tearDown];
}

@end
