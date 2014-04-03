//
//  CSHomePageControlDataSource.h
//  EasyReader
//
//  Created by Joseph Lorich on 4/1/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSCollectionPageControl.h"

@class EZRHomeViewController;

/**
 * A data source for the page control on the home view controller
 */
@interface EZRHomePageControlDataSource : NSObject <CSCollectionPageControlDataSource>

/**
 * Initializes a new page control data source for the given home view controller instance
 *
 * @param homeController The home view controller
 */
- (instancetype)initWithController:(EZRHomeViewController *)homeController;
    
@end
