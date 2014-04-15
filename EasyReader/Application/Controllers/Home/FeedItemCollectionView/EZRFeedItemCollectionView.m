//
//  CSFeedItemCollectionView.m
//  EasyReader
//
//  Created by Michael Beattie on 3/17/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import "EZRFeedItemCollectionView.h"
#import "EZRFeedItemCollectionViewCell.h"

@implementation EZRFeedItemCollectionView

#pragma mark - Initializers

/**
 * Calls setup on init with coder
 */
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self.layer setCornerRadius:5.0f];
        self.clipsToBounds = YES;
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        
        CGFloat width = CGRectGetWidth(self.frame);
        CGFloat height = CGRectGetHeight(self.frame);
        
        flowLayout.itemSize = CGSizeMake(width, height);
        
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 0;
        self.collectionViewLayout = flowLayout;
        
        self.pagingEnabled = YES;
    }
    
    return self;
}


#pragma mark - Property implementations

/**
 * Returns the currently visible feed item
 */
- (FeedItem *) currentFeedItem {
    NSArray *visibleIndexPaths = self.indexPathsForVisibleItems;
    FeedItem *feeditem;
    
    if ([visibleIndexPaths count] > 0)
    {
        NSIndexPath *currentIndexPath = [self.indexPathsForVisibleItems objectAtIndex:0];
        EZRFeedItemCollectionViewCell *cell = (EZRFeedItemCollectionViewCell *)[self cellForItemAtIndexPath:currentIndexPath];
        
        feeditem = cell.feedItem;
    }
    
    return feeditem;
}


@end
