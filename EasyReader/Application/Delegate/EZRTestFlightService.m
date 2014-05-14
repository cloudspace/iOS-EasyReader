//
//  EZRTestFlightService.m
//  EasyReader
//
//  Created by Joseph Lorich on 4/11/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import "EZRTestFlightService.h"
#import <TestFlightSDK/TestFlight.h>

@implementation EZRTestFlightService

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    #ifdef STAGING
        [TestFlight takeOff:@"d9e0e8eb-44ab-4b9a-83ce-2f944a0f37ef"];
    #endif
    
    return YES;
}

@end
