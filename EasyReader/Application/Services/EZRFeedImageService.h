//
//  EZRFeedImagePrefetchService.h
//  EasyReader
//
//  Created by Joseph Lorich on 3/27/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * A service to process and cache feed images
 */
@interface EZRFeedImageService : NSObject


/**
 * Prefetches and caches an image and it's blurred equivalent for use as background images
 *
 * @param urlString the URL of the image to process
 */
- (void)prefetchImageAtURLString:(NSString *)urlString;

/**
 * Loads the cached image if it exists
 *
 * @param urlString the URL of the image to look for in the cache
 */
- (UIImage *)imageForURLString:(NSString *)urlString;

/**
 * Loads the cached blurred image if it exists
 *
 * @param urlString the URL of the image to look for in the cache
 */
- (UIImage *)blurredForURLString:(NSString *)urlString;


@end
