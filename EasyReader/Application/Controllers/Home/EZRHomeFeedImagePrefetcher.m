//
//  EZRHomeFeedImagePrefetcher.m
//  EasyReader
//
//  Created by Joseph Lorich on 4/14/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import "EZRHomeFeedImagePrefetcher.h"
#import "EZRFeedImageService.h"

@implementation EZRHomeFeedImagePrefetcher


/**
 * Fetches the current feed item image, then prefetches after
 */
//- (void)prefetchFirstImages
//{
//    if (_currentFeedItem.imageIphoneRetina)
//    {
//        [[EZRFeedImageService shared] fetchImageAtURLString: _currentFeedItem.imageIphoneRetina success:^(UIImage *image, UIImage *blurredImage) {
//            [self prefetchImagesNearIndex:1 count:2];
//        } failure:^{
//            
//        }];
//    }
//    
//}
//- (void)prefetchImagesFromArray:(NSArray*) sortedFeedItems NearIndex:(NSInteger)currentPageIndex count:(NSInteger)count
//{
//    NSInteger feedItemsCount = [collectionViewDataSource.sortedFeedItems count];
//    
//    NSInteger beginFetchIndex = currentPageIndex - count > 0 ? currentPageIndex - count : 0;
//    NSInteger beforeFetchCount = currentPageIndex - count > 0 ?  count : currentPageIndex - beginFetchIndex;
//    NSInteger afterFetchCount = currentPageIndex + count + 1 > feedItemsCount ? feedItemsCount - currentPageIndex : count;
//    
//    NSRange fetchRange = {beginFetchIndex, beforeFetchCount+afterFetchCount};
//    
//    NSArray *itemsToPrefetch = [collectionViewDataSource.sortedFeedItems subarrayWithRange:fetchRange];
//    
//    [[EZRFeedImageService shared] prefetchImagesForFeedItems:itemsToPrefetch];
//    
//}

@end
