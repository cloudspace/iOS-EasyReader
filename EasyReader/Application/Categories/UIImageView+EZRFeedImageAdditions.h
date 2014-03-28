//
//  UIImage+EZRFeedImageAdditions.h
//  EasyReader
//
//  Created by Joseph Lorich on 3/28/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (EZRFeedImageAdditions)


/**
 * Sets an image with the given URL string
 */
- (void)setImageForURLString:(NSString *)urlString;

/**
 * Sets the blurred image for the given URL string
 */
- (void)setBlurredImageForURLString:(NSString *)urlString;


@end
