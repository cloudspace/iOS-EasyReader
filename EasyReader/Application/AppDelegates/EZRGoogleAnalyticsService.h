//
//  EZRGoogleAnalyticsService.h
//  EasyReader
//
//  Created by Joseph Lorich on 4/29/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import "SRVApplicationDelegateService.h"

@interface EZRGoogleAnalyticsService : SRVApplicationDelegateService

/**
 * Sends a screen view to Google Analytics
 *
 * @param viewName The view name to send to google analytics
 */
- (void)sendView:(NSString *)viewName;
    
@end
