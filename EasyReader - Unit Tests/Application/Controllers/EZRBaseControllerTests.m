//
//  EZRBaseControllerTests.m
//  EasyReader
//
//  Created by Michael Beattie on 3/28/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import "EZRBaseControllerTests.h"
#import "APIClient.h"

@implementation EZRBaseControllerTests

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
