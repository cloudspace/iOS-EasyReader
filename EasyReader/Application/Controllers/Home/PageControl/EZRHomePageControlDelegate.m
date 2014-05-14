//
//  CSHomePageControlDelegate.m
//  EasyReader
//
//  Created by Joseph Lorich on 4/1/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import "EZRHomePageControlDelegate.h"
#import "EZRFeedItemCollectionView.h"

@interface EZRHomePageControlDelegate ()

/// The feed item collection view
@property (nonatomic, weak) IBOutlet EZRFeedItemCollectionView *collectionView_feedItems;

@end


@implementation EZRHomePageControlDelegate

- (void)pageControl:(CSCollectionPageControl *)pageControl didSelectPageAtIndex:(NSInteger)index
{
    NSIndexPath *destinationIndexPath = [NSIndexPath indexPathForItem:index inSection:0];
    
    [self.collectionView_feedItems scrollToItemAtIndexPath:destinationIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
}


@end
