//
//  EZRFeedImagePrefetchService.m
//  EasyReader
//
//  Created by Joseph Lorich on 3/27/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import "EZRFeedImageService.h"
#import "UIImageView+AFNetworking.h"
#import "SDImageCache.h"
#import "SDWebImageDownloader.h"

static dispatch_once_t pred;
static SDImageCache *sharedBlurCache;

@implementation EZRFeedImageService



- (void)prefetchImageAtURLString:(NSString *)urlString
{
    SDWebImageDownloader *downloader = [SDWebImageDownloader sharedDownloader];
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    [downloader downloadImageWithURL:url options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        // Nothing, we don't really care about progress
    } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
        // Store the image
        if (image && finished)
        {
            SDImageCache *imageCache = [self sharedImageCache];
            SDImageCache *blurredImageCache = [self sharedBlurredImageCache];

            [imageCache storeImage:image forKey:urlString];
            [blurredImageCache storeImage:[self blurImage:image] forKey:urlString];
        }
    }];
}

- (UIImage *)blurImage:(UIImage*)image
{
    return image;
}

- (UIImage *)imageForURLString:(NSString *)urlString
{
    SDImageCache *imageCache = [self sharedImageCache];
    imageCache queryDiskCacheForKey:<#(NSString *)#> done:<#^(UIImage *image, SDImageCacheType cacheType)doneBlock#>
}


/**
 * Loads the image at the given urlString and calls setImageAndblur on success
 *
 * @param urlString the URL of the image to load
 */
- (void)loadImageWithURLString:(NSString *)urlString
{
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    
    [self.imageView_background setImageWithURLRequest:request
                                     placeholderImage:nil
                                              success: [self setImageAndBlur]
                                              failure:nil];
}

/**
 * Generates a block which will set the background image and then enerate a reflected blurred bottom view
 */
- (AFImageBlock)setImageAndBlur
{
    return ^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        [self.imageView_background setImage:image];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            CIImage *inputImage = [[CIImage alloc] initWithImage:image];
            
            CIFilter *blurFilter = [CIFilter filterWithName:@"CIGaussianBlur"];
            
            [blurFilter setDefaults];
            [blurFilter setValue: inputImage forKey: @"inputImage"];
            [blurFilter setValue: [NSNumber numberWithFloat:6.0f]
                          forKey:@"inputRadius"];
            
            
            CIImage *outputImage = [blurFilter valueForKey: @"outputImage"];
            
            CIContext *context = [CIContext contextWithOptions:nil];
            
            UIImage *blurredImage = [UIImage imageWithCGImage:[context createCGImage:outputImage fromRect:outputImage.extent]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.imageView_backgroundReflection setImage:blurredImage];
                [self.imageView_backgroundReflection setTransform:CGAffineTransformMakeScale(1, -1)];
            });
        });
    };
}


#pragma mark - Private Methods

/**
 * Returns a shared SDImageCache for feed item images
 */
- (SDImageCache *)sharedImageCache {
    dispatch_once(&pred, ^{
        if (sharedBlurCache)
        {
            return;
        }
        sharedBlurCache = [[SDImageCache alloc] initWithNamespace:@"EZRBlurredFeedItemImage"];
    });
    
    return sharedBlurCache;
}

/**
 * Returns a shared SDImageCache for blurred feed item images
 */
- (SDImageCache *)sharedBlurredImageCache {
    dispatch_once(&pred, ^{
        if (sharedBlurCache)
        {
            return;
        }
        
        sharedBlurCache = [[SDImageCache alloc] initWithNamespace:@"EZRFeedItemImages"];
    });
    
    return sharedBlurCache;
}

@end
