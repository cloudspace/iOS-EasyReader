//
//  CSServiceOrientedAppDelegate.h
//  EasyReader
//
//  Created by Joseph Lorich on 3/20/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SOApplicationDelegateService;

@interface SOApplicationDelegate : UIResponder


#pragma mark - Properties

/// An array of AppDelegate service objects
@property (strong, readonly) NSArray *services;


#pragma mark - Methods

/**
 * Executes the given selector on all appropriate services
 *
 * @param argument A pointer to the argument to be passed along
 */
- (void)invokeServiceMethodWithSelector:(SEL)selector withArgument:(void*)argument;

/**
 * Registers a new service with the app delegate
 */
- (void) registerService:(SOApplicationDelegateService *)service;


@end
