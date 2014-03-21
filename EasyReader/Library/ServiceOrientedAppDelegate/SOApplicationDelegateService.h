//
//  CSAppDelegateService.h
//  EasyReader
//
//  Created by Joseph Lorich on 3/20/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SOApplicationDelegateService : NSObject <UIApplicationDelegate>

/**
 * A shared singleton app delegate service object
 */
+ (SOApplicationDelegateService *)shared;

@end
