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
