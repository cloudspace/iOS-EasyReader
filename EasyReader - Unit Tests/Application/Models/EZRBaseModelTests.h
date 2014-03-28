//
//  EZRBaseModelTests.h
//  EasyReader
//
//  Created by Alfredo Uribe on 3/27/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import "CSBaseTestCase.h"

/**
 * A base tests class for all easy reader model tests
 */
@interface EZRBaseModelTests : CSBaseTestCase
{
    NSBundle *bundle;
    id mockAPIClient;
    id mockFBSession;
    id mockObserver;
}

@end
