//
//  UIImageView+EZRFeedImageAdditions.m
//  EasyReader
//
//  Created by Joseph Lorich on 3/28/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import <objc/runtime.h>

#import "UIImageView+EZRFeedImageAdditions.h"
#import "EZRFeedImageService.h"

static void *__ImageURLStringKey;



@implementation UIImageView (EZRFeedImageAdditions)

@dynamic imageURLString;

- (void)setImageForURLString:(NSString *)urlString
{
    if (!urlString) return;
    
    NSLog(@"LOADING IMAGE FOR: %@", urlString);
    
    EZRFeedImageService *feedImageService = [EZRFeedImageService shared];
    
    objc_setAssociatedObject(self, &__ImageURLStringKey, urlString, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [feedImageService fetchImageAtURLString:urlString
                                    success:
    ^(UIImage *image, UIImage *blurredImage) {
        NSString *currentURLString = objc_getAssociatedObject(self, &__ImageURLStringKey);
        
        if (urlString == currentURLString)
        {
          [self setImage:image];
        }
        {
            NSLog(@"currentl URL != loaded url");
        }
    }
                                    failure:
    ^{
        NSLog(@"image set failed for: %@", urlString);
        [self setImage:nil];
    }];
}


- (void)setBlurredImageForURLString:(NSString *)urlString
{
    if (!urlString) return;
    
    EZRFeedImageService *feedImageService = [EZRFeedImageService shared];
    
    objc_setAssociatedObject(self, &__ImageURLStringKey, urlString, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [feedImageService fetchImageAtURLString:urlString
                                    success:
     ^(UIImage *image, UIImage *blurredImage) {
         NSString *currentURLString = objc_getAssociatedObject(self, &__ImageURLStringKey);
         
         if (urlString == currentURLString)
         {
             [self setImage:blurredImage];
         }
         {
             NSLog(@"currentl URL != loaded url");
         }
     }
                                    failure:
     ^{
         [self setImage:nil];
     }];
}

@end
