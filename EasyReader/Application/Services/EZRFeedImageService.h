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
 * Prefetches all the images for the given feed items
 *
 * @param feedItems The array of feed items to preFetch images for
 */
- (void)prefetchImagesForFeedItems:(NSArray *)feedItems;

/**
 * Prefetches and caches an image and it's blurred equivalent for use as background images
 *
 * @param urlString the URL of the image to process
 */
- (void)fetchImageAtURLString:(NSString *)urlString;

/**
 * Prefetches and caches an image and it's blurred equivalent for use as background images
 *
 * @param urlString the URL of the image to process
 * @param success A block that gets executed after successful fetching and processing
 * @param success A block that gets executed after image fetching failure
 */
- (void)fetchImageAtURLString:(NSString *)urlString
                      success:(void (^)(UIImage *image, UIImage *blurredImage))success
                      failure:(void (^)())failure;

/**
 * Creates or returns a shared EZRFeedImageService object
 */
+ (EZRFeedImageService *)shared;


@end
