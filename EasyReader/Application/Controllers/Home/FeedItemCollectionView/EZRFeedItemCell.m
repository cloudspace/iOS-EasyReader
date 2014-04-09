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
}


@end
