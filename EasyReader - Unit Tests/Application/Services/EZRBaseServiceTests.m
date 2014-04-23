//
//  EZRBaseServiceTests.m
//  EasyReader
//
//  Created by Alfredo Uribe on 4/18/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import "EZRBaseServiceTests.h"
#import "EZRFeedImageService.h"
#import "APIClient.h"

@implementation EZRBaseServiceTests

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
    [super tearDown];
}

@end
