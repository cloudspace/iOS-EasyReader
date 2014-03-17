//
//  CSFeedItemCollectionView.m
//  EasyReader
//
//  Created by Michael Beattie on 3/17/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import "CSFeedItemCollectionView.h"
#import "FeedCollectionViewDataSource.h"

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
    self.pagingEnabled = YES;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    _currentFeedItem = [self.indexPathsForSelectedItems objectAtIndex:0];
}

@end
