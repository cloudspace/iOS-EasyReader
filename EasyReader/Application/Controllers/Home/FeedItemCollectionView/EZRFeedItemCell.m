//
//  CSFeedItemCell.m
//  EasyReader
//
//  Created by Joseph Lorich on 3/17/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import "EZRFeedItemCell.h"
#import "UIColor+EZRSharedColorAdditions.h"
#import "UIImageView+EZRFeedImageAdditions.h"

typedef void (^AFImageBlock)(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image);

@implementation EZRFeedItemCell


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        UIColor *transGray =[UIColor EZR_charcoal];
        [self setBackgroundColor:[transGray colorWithAlphaComponent:1.0]];
    }
    
    return self;
}



- (void)layoutSubviews
{
    [super layoutSubviews];
    
//    UIColor *transGray =[UIColor EZR_charcoal];
//    [self.info_view setBackgroundColor:[UIColor EZR_charcoalWithOpacity:0.75]];
  //  [self setBackgroundColor:transGray];
//    [self applyInfoGradient];
//    [self applySummaryGradient];


//    [self setAlpha:0.75];
    
    
}

- (void)setFeedItem:(FeedItem *)feedItem
{
    _feedItem = feedItem;
    
    self.label_headline.text = feedItem.title;
    self.label_source.text = feedItem.headline;
    self.label_summary.text = feedItem.summary;
    self.imageView_background.image = nil;
    self.imageView_backgroundReflection.image = nil;
    
    
    [self.info_view setBackgroundColor:[[UIColor lightGrayColor] colorWithAlphaComponent:0.60]];
    [self.imageView_background setImageForURLString:feedItem.image_iphone_retina];
    [self.imageView_backgroundReflection setBlurredImageForURLString:feedItem.image_iphone_retina];
}
//
///**
// * Generates a block which will set the background image and then enerate a reflected blurred bottom view
// */
//- (AFImageBlock)setImageAndBlur
//{
//    return ^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
//        [self.imageView_background setImage:image];
//        
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
//            CIImage *inputImage = [[CIImage alloc] initWithImage:image];
//            
//            CIFilter *blurFilter = [CIFilter filterWithName:@"CIGaussianBlur"];
//            
//            [blurFilter setDefaults];
//            [blurFilter setValue: inputImage forKey: @"inputImage"];
//            [blurFilter setValue: [NSNumber numberWithFloat:6.0f]
//                          forKey:@"inputRadius"];
//            
//            
//            CIImage *outputImage = [blurFilter valueForKey: @"outputImage"];
//            
//            CIContext *context = [CIContext contextWithOptions:nil];
//            
//            UIImage *blurredImage = [UIImage imageWithCGImage:[context createCGImage:outputImage fromRect:outputImage.extent]];
//            
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [self.imageView_backgroundReflection setImage:blurredImage];
//                [self.imageView_backgroundReflection setTransform:CGAffineTransformMakeScale(1, -1)];
//            });
//        });
//    };
//}
//
//
//- (void)applyInfoGradient
//{
//    [self.info_view setBackgroundColor:[UIColor clearColor]];
//    
//    // Create a new gradient object
//    CAGradientLayer *gradient = [CAGradientLayer layer];
//    
//    // Set the dimensions equal to the info container
//    gradient.frame = self.info_view.bounds;
//    
//    // Define and set array of gradient colors
//    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor EZR_charcoalWithOpacity:0.7] CGColor],
//                                                (id)[[UIColor EZR_charcoalWithOpacity:0.9] CGColor],
//                                                (id)[[UIColor EZR_charcoal] CGColor],nil];
//    
//    // Define and set array of color stop positions
//    gradient.locations = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.02],
//                                                   [NSNumber numberWithFloat:0.05],
//                                                   [NSNumber numberWithFloat:0.1], nil];
//    
//    // Apply the gradient
//    [self.info_view.layer insertSublayer:gradient atIndex:0];
//}
//
///**
// * Create and apply a gradient ask a mask to the feedItemSummary
// */
//- (void)applySummaryGradient
//{
//    // Create a new gradient object
//    CAGradientLayer *gradient = [CAGradientLayer layer];
//    
//    // Set the dimensions equal to the info container
//    gradient.frame = self.label_summary.bounds;
//    
//    // Define and set array of gradient colors
//    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor whiteColor] CGColor], (id)[[UIColor clearColor] CGColor],nil];
//    
//    // Define and set array of color stop positions
//    gradient.locations = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.30],
//                                                   [NSNumber numberWithFloat:0.90], nil];
//    
//    // Apply the gradient
//    self.label_summary.layer.mask = gradient;
//}

@end
