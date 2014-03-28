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
#import "FeedItem.h"
#import "GPUImage.h"

/// The shared instance dispatch once predicate
static dispatch_once_t pred;

/// The shared EZRFeedImageService instance
static EZRFeedImageService *sharedInstance;


@implementation EZRFeedImageService
{
    /// A dictionary keyed on urlStrings of NSArrays of blocks to run on image processing success
    NSMutableDictionary *successBlocks;

    /// A dictionary keyed on urlStrings of NSArrays of blocks to run on image processing failure
    NSMutableDictionary *failureBlocks;
    
    /// An array of URLs that are currently being processed
    NSMutableArray *imageURLsCurrentlyBeingProcessed;
    
    /// A cache of feed item images
    SDImageCache *imageCache;

    /// A cache of blurred item images
    SDImageCache *blurredImageCache;
}


+ (EZRFeedImageService *)shared {
    dispatch_once(&pred, ^{
        if (sharedInstance)
        {
            return;
        }
        sharedInstance = [[EZRFeedImageService alloc] init];
    });
    
    return sharedInstance;
}


#pragma mark - Public methods

- (void)prefetchImagesForFeedItems:(NSArray *)feedItems
{
//    for (FeedItem *item in feedItems)
//    {
//        if (item.imageIphoneRetina)
//        {
//          [self fetchImageAtURLString:item.imageIphoneRetina];
//        }
//    }
}

- (void)fetchImageAtURLString:(NSString *)urlString
{
    [self fetchImageAtURLString:urlString
                        success:nil
                        failure:nil];
}

- (void)fetchImageAtURLString:(NSString *)urlString
                      success:(void (^)(UIImage *image, UIImage *blurredImage))success
                      failure:(void (^)())failure
{
    @synchronized(self)
    {
        [self addCompletionBlocksForURLString:urlString success:success failure:failure];
        
        if (![self isImageCurrentlyBeingProcessedForURLString:urlString])
        {
            [self markImageForURLString:urlString asBeingProcessed:YES];
            
            [imageCache queryDiskCacheForKey:urlString done:^(UIImage *image, SDImageCacheType cacheType) {
                [blurredImageCache queryDiskCacheForKey:urlString done:^(UIImage *blurredImage, SDImageCacheType blurredCacheType) {
                    if (image && blurredImage)
                    {
                        NSLog(@"FOUND CACHED IMAGES");
                        [self triggerCompletionBlocksForUrlString:urlString withImage:image blurredImage:blurredImage];
                    }
                    else
                    {
                        NSLog(@"NO CACHE FOUND, DOWNLOADING");
                        [self downloadAndProcessImageAtURLString:urlString];
                    }
                }];
            }];
        }
    }
}

- (void)downloadAndProcessImageAtURLString:(NSString *)urlString
{
    [self downloadImageAtURLString:urlString
                           success:
     ^(UIImage *image) {
         [imageCache storeImage:image forKey:urlString];
         
         UIImage *blurredImage = [self blurImage:image];
         
         [blurredImageCache storeImage:blurredImage forKey:urlString];
         
         [self markImageForURLString:urlString asBeingProcessed:NO];
         
         [self triggerCompletionBlocksForUrlString:urlString withImage:image blurredImage:blurredImage];
         
     } failure:^{
         [self triggerCompletionBlocksForUrlString:urlString withImage:nil blurredImage:nil];
     }];
}

/**
 * Downloads an image at the given URL string and returns it in the block
 *
 * @param success A block that is executed on a successful image download
 * @param failure A block that is executed on a failed image download
 */
- (void)downloadImageAtURLString:(NSString *)urlString
                      success:(void (^)(UIImage *image))success
                      failure:(void (^)())failure
{
    SDWebImageDownloader *downloader = [SDWebImageDownloader sharedDownloader];
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    [downloader downloadImageWithURL:url options:0 progress:nil completed:
     ^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
         if (image && finished)
         {
             if (success) success(image);
         }
         else
         {
             if (failure) failure();
         }
     }];

}

/**
 * Initializes a new EZRFeedImageService
 */
- (id) init
{
    self = [super init];
    
    if (self)
    {
        successBlocks = [[NSMutableDictionary alloc] init];
        failureBlocks = [[NSMutableDictionary alloc] init];
        imageCache = [[SDImageCache alloc] initWithNamespace:@"EZRFeedItemImages"];
        blurredImageCache = [[SDImageCache alloc] initWithNamespace:@"EZRBlurredFeedItemImages"];
        
        imageURLsCurrentlyBeingProcessed = [[NSMutableArray alloc] init];
    }
    
    return self;
}


#pragma mark - Private Methods

- (void)addCompletionBlocksForURLString:(NSString *)urlString
                                success:(void (^)(UIImage *image, UIImage *blurredImage))success
                                failure:(void (^)())failure
{
    [self addSuccessCompletionBlockForURLString:urlString success:success];
    [self addFailureCompletionBlockForURLString:urlString failure:failure];
}

- (void)addSuccessCompletionBlockForURLString:(NSString *)urlString
                                      success:(void (^)(UIImage *image, UIImage *blurredImage))success
{
    if (!success) return;
    
    NSArray *successBlocksArray = [successBlocks objectForKey:urlString];
    
    if (!successBlocksArray)
    {
        successBlocksArray = @[success];
    }
    else
    {
        successBlocksArray = [successBlocksArray arrayByAddingObject:success];
    }
    
    
    [successBlocks setValue:successBlocksArray forKey:urlString];
}

- (void)addFailureCompletionBlockForURLString:(NSString *)urlString
                                      failure:(void (^)())failure
{
    if (!failure) return;
    
    NSArray *failureBlocksArray = [failureBlocks objectForKey:urlString];
    
    if (!failureBlocksArray)
    {
        failureBlocksArray = @[failure];
    }
    else
    {
        failureBlocksArray = [failureBlocksArray arrayByAddingObject:failure];
    }
    
    [failureBlocks setValue:failureBlocksArray forKey:urlString];
}


/**
 * Triggers completion blocks for the given urlString
 *
 * @param image The image to blur
 */
- (void)triggerCompletionBlocksForUrlString:(NSString *)urlString
                                  withImage:(UIImage*)image
                               blurredImage:(UIImage *)blurredImage
{
    @synchronized(self)
    {
        if (image && blurredImage)
        {
            for (void(^block)(UIImage *image, UIImage *blurredImage) in [successBlocks objectForKey:urlString])
            {
                block(image, blurredImage);
            }
            
        }
        else
        {
            for (void(^block)() in [failureBlocks objectForKey:urlString])
            {
                block();
            }
        }
        
        [successBlocks setValue:nil forKey:urlString];
        [failureBlocks setValue:nil forKey:urlString];
    }
}


/**
 * Flags a given URL string as currently being processed
 *
 * @param urlString The urlString to flag as being processed
 */
- (void)markImageForURLString:(NSString *)urlString asBeingProcessed:(BOOL)processing
{
    @synchronized(self)
    {
        if (processing)
        {
          [imageURLsCurrentlyBeingProcessed addObject:urlString];
        }
        else
        {
          [imageURLsCurrentlyBeingProcessed removeObject:urlString];
        }
    }
}

/**
 * Checks if the given urlString is currently being processed
 *
 * @param image The image to blur
 */
- (BOOL)isImageCurrentlyBeingProcessedForURLString:(NSString *)urlString
{
    return [imageURLsCurrentlyBeingProcessed containsObject:urlString];
}

/**
 * Creates a blurred UIImage appropriate for the feed item
 *
 * @param image The image to blur
 */
- (UIImage *)blurImage:(UIImage*)image
{
    NSLog(@"processing blur");
    CIContext *context = [CIContext contextWithOptions:nil];
    
    CIImage *inputImage = [[CIImage alloc] initWithImage:image];
    
    CIFilter *blurFilter = [CIFilter filterWithName:@"CIGaussianBlur"];
    
    [blurFilter setDefaults];
    [blurFilter setValue: inputImage forKey: @"inputImage"];
    [blurFilter setValue: [NSNumber numberWithFloat:20.0f] forKey:@"inputRadius"];
    
    CIImage *result = [blurFilter valueForKey: kCIOutputImageKey];
    
    UIImage *blurredImage = [UIImage imageWithCGImage:[context createCGImage:result fromRect:inputImage.extent] scale:1.0 orientation:UIImageOrientationDownMirrored];
   
//    GPUImageSaturationFilter *saturationFilter = [[GPUImageSaturationFilter alloc] init];
//    saturationFilter.saturation = 1.5f;
//    
//    blurredImage = [saturationFilter imageByFilteringImage:blurredImage];

    NSLog(@"finished blur");
    return blurredImage;
}

@end
