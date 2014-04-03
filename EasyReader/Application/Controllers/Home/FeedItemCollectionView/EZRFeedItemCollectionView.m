//
//  CSFeedItemCollectionView.m
//  EasyReader
//
//  Created by Michael Beattie on 3/17/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import "EZRFeedItemCollectionView.h"
#import "EZRHomeCollectionViewDataSource.h"
#import "EZRFeedItemCell.h"

@implementation EZRFeedItemCollectionView

#pragma mark - Initializers

/**
 * Calls setup on init with frame
 */
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setup];
    }
    
    return self;
}

/**
 * Calls setup on init with coder
 */
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if ( self ) {
        [self setup];
    }
    
    return self;
}

/**
 * Calls setup on init
 */
- (id)init {
    self = [super init];
    
    if ( self ) {
        [self setup];
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
        EZRFeedItemCell *cell = (EZRFeedItemCell *)[self cellForItemAtIndexPath:currentIndexPath];
        
        feeditem = cell.feedItem;
    }
    
    return feeditem;
}


#pragma mark - Private methods
/**
 * Adds paging and a sets a fullscreen flowlayout
 */
- (void)setup {
    self.pagingEnabled = YES;
    
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.collectionViewLayout;

    flowLayout.minimumLineSpacing = 0.0;
    flowLayout.itemSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
}



@end
