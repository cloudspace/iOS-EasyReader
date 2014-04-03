//
//  UIImage+EZRFeedImageAdditions.h
//  EasyReader
//
//  Created by Joseph Lorich on 3/28/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * Additions to UIImageView to assist in downloading and processing feed images
 */
@interface UIImageView (EZRFeedImageAdditions)

/// The currently desired image URL string for this UIImageView
///
/// This is necessary since the download requests are in a background thread and we aren't guaranteed the order
/// they come back.  Since UIImageViews are often reloaded in collection or table view we use this property to
/// verify we are only updating images that are still desired
@property (strong, nonatomic) NSString *imageURLString;

/**
 * Sets an image with the given URL string
 * @param urlString The url string where the image is located
 */
- (void)setImageForURLString:(NSString *)urlString;

/**
 * Sets the blurred image for the given URL string
 * @param urlString The url string where the original image is located
 */
- (void)setBlurredImageForURLString:(NSString *)urlString;


@end
