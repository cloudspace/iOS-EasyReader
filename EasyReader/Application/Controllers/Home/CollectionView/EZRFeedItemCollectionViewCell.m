//
//  CSFeedItemCell.m
//  EasyReader
//
//  Created by Joseph Lorich on 3/17/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import "EZRFeedItemCollectionViewCell.h"
#import "UIColor+EZRSharedColorAdditions.h"
#import "UIImageView+EZRFeedImageAdditions.h"

typedef void (^AFImageBlock)(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image);

@implementation EZRFeedItemCollectionViewCell
{
    /// The tap recognizer on the title label
    UITapGestureRecognizer *tapRecognizer_title;
}


#pragma mark - Public Methods

- (void)setFeedItem:(FeedItem *)feedItem
{
    _feedItem = feedItem;
    
    self.label_headline.text = feedItem.title;
    self.label_source.text = feedItem.headline;
    self.label_summary.text = feedItem.summary;
    self.imageView_background.image = nil;
    self.imageView_backgroundReflection.image = nil; 
    
    
    [self.info_view setBackgroundColor:[[UIColor darkGrayColor] colorWithAlphaComponent:0.60]];
    [self.imageView_background setImageForURLString:feedItem.imageIphoneRetina];
    [self.imageView_backgroundReflection setBlurredImageForURLString:feedItem.imageIphoneRetina];
    
    [self appleStyles];
    
    if (!tapRecognizer_title) {
        [self addTitleGestureRecognizer];
    }
}

#pragma mark - Private Methods

/**
 * Styles the view
 */
- (void)appleStyles {
    UIColor *transGray =[UIColor EZR_charcoal];
    [self setBackgroundColor:[transGray colorWithAlphaComponent:1.0]];
}

/**
 * Adds a tap gesture recognizer to the title label
 */
- (void)addTitleGestureRecognizer {
    self.label_headline.userInteractionEnabled = YES;
    
    tapRecognizer_title = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapHeadlineLabel:)];
    [tapRecognizer_title setNumberOfTapsRequired:1];

    [self.label_headline addGestureRecognizer:tapRecognizer_title];

}

/**
 * Triggered by the tap gesture recognizer when the title label is tapped
 */
- (void)didTapHeadlineLabel:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didTapHeadlineOfCell:)]) {
        [self.delegate didTapHeadlineOfCell:self];
    }
}


@end
