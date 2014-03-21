//
//  CSFeedItemCollectionView.m
//  EasyReader
//
//  Created by Michael Beattie on 3/17/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import "CSFeedItemCollectionView.h"
#import "CSFeedItemCollectionViewDataSource.h"
#import "CSFeedItemCell.h"

@implementation CSFeedItemCollectionView

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
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if ( self ) {
        [self setup];
    }
    return self;
}

/**
 * Calls setup on init
 */
- (id)init
{
    self = [super init];
    
    if ( self ) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    // Our app uses paging
    self.pagingEnabled = YES;
    
    // Set flowlayout minimum spacing to 0 in order to keep views centered
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    flowLayout.minimumLineSpacing = 0.0;
    
    // Resize cells to match container
    flowLayout.itemSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
}

- (FeedItem *) currentFeedItem
{
    NSArray *visibleIndexPaths = self.indexPathsForVisibleItems;
    FeedItem *feeditem;
    
    if ([visibleIndexPaths count] > 0)
    {
        // Get the array of visible feed cells
        NSIndexPath *currentIndexPath = [self.indexPathsForVisibleItems objectAtIndex:0];
        CSFeedItemCell *cell = (CSFeedItemCell *)[self cellForItemAtIndexPath:currentIndexPath];
        
        feeditem = cell.feedItem;
    }
    
    return feeditem;
}

@end
