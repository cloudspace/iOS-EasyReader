//
//  CSFeedItemCollectionView.m
//  EasyReader
//
//  Created by Michael Beattie on 3/17/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import "EZRFeedItemCollectionView.h"
#import "EZRFeedItemCollectionViewCell.h"
#import "EZRHomeViewController.h"

@implementation EZRFeedItemCollectionView
{
    UICollectionViewFlowLayout *flowLayout;
}
#pragma mark - Initializers

/**
 * Calls setup on init with coder
 */
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self.layer setCornerRadius:5.0f];
        //self.clipsToBounds = YES;
        
        flowLayout = [[UICollectionViewFlowLayout alloc] init];
        
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 0;
        
        self.collectionViewLayout = flowLayout;
        
        self.pagingEnabled = YES;
    }
    
    [self setupTapRecognizer];
    [self setupRefreshIndicator];
    
    return self;
}

- (void)setupTapRecognizer {
    UITapGestureRecognizer *singleTapGestureRecognizer =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(singleTap:)];
    singleTapGestureRecognizer.numberOfTapsRequired = 1;
    singleTapGestureRecognizer.enabled = YES;
    singleTapGestureRecognizer.cancelsTouchesInView = NO;
    [self addGestureRecognizer:singleTapGestureRecognizer];
}

- (void)setupRefreshIndicator {
    self.indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.indicator.frame = CGRectMake(10.0, ([self frame].size.height-40.0)/2, 40.0, 40.0);
    [self addSubview:self.indicator];
    [self bringSubviewToFront:self.indicator];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = TRUE;
    self.delegate.isRefreshing = NO;
}

- (void)singleTap:(UITapGestureRecognizer *)gesture {
    float viewWidth = [self frame].size.width;
    float x = [gesture locationInView:self].x - (viewWidth*[self currentPageIndex]);
    EZRHomeViewController *controller = self.delegate.controller;
    
    if (x <= viewWidth/4 && [self currentPageIndex] != 0) {
        [self scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:[self currentPageIndex]-1 inSection:0]
                     atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                             animated:YES];
    } else if (x >= (viewWidth*3)/4 &&
               [self currentPageIndex] != [[[controller currentFeedsProvider] feedItems] count]-1) {
        [self scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:[self currentPageIndex]+1 inSection:0]
                     atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                             animated:YES];
    }
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    
    flowLayout.itemSize = CGSizeMake(width, height);
}


#pragma mark - Property implementations

/**
 * Returns the most centered currently visible feed item
 */
- (FeedItem *) currentFeedItem {
    NSIndexPath *currentItemIndexPath = [NSIndexPath indexPathForRow:[self currentPageIndex] inSection:0];
    
    EZRFeedItemCollectionViewCell *cell = (EZRFeedItemCollectionViewCell *)[self cellForItemAtIndexPath:currentItemIndexPath];
    
    if (cell) {
        return cell.feedItem;
    } else {
        return nil;
    }
}

/**
 * Returns the currently visible feed item
 */
- (NSInteger) currentPageIndex {
    CGFloat centerX = self.contentOffset.x + CGRectGetWidth(self.frame)/2;
    
    for (NSIndexPath *visibleIndexPath in self.indexPathsForVisibleItems) {
        
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:visibleIndexPath];

        CGFloat cellMinX = CGRectGetMinX(attributes.frame);
        CGFloat cellMaxX = CGRectGetMaxX(attributes.frame);
        
        if (cellMinX <= centerX && cellMaxX >= centerX) {
            return visibleIndexPath.row;
        }
    }
    
    return 0;
}


@end
