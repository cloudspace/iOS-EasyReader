//
//  UIImageView+EZRFeedImageAdditions.m
//  EasyReader
//
//  Created by Joseph Lorich on 3/28/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import "UIImageView+EZRFeedImageAdditions.h"
#import "EZRFeedImageService.h"

@implementation UIImageView (EZRFeedImageAdditions)

- (void)setImageForURLString:(NSString *)urlString
{
    if (!urlString) return;
    
    EZRFeedImageService *feedImageService = [EZRFeedImageService shared];
    
    [feedImageService fetchImageAtURLString:urlString
                                    success:
    ^(UIImage *image, UIImage *blurredImage) {
        [self setImage:image];
    }
                                    failure:
    ^{
        [self setImage:nil];
    }];
}


- (void)setBlurredImageForURLString:(NSString *)urlString
{
    if (!urlString) return;
    
    EZRFeedImageService *feedImageService = [EZRFeedImageService shared];
    
    [feedImageService fetchImageAtURLString:urlString
                                    success:
     ^(UIImage *image, UIImage *blurredImage) {
         [self setImage:blurredImage];
     }
                                    failure:
     ^{
         [self setImage:nil];
     }];
}

@end
