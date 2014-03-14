//
//  CSFeedItemContainerViewController.m
//  EasyReader
//
//  Created by Michael Beattie on 3/7/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import "CSFeedItemContainerViewController.h"
#import "FeedItemViewController.h"

@interface CSFeedItemContainerViewController ()
{
    CSHorizontalScrollView *scrollViewDelegate;
}

@end

@implementation CSFeedItemContainerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
  
    scrollViewDelegate = [[CSHorizontalScrollView alloc] initWithScrollView:self.scrollViewController
                                                               storyboard:[UIStoryboard storyboardWithName:@"Main_iPhone" bundle:[NSBundle mainBundle]]
                                                            andIdentifier:@"FeedItem"];
    [self.scrollViewController setDelegate:scrollViewDelegate];

    _currentUser = [User current];
    _feedItemsSet = [[NSMutableSet alloc] init];

    [self observeRelationship:@keypath(self.currentUser.feeds)
                changeBlock:^(__weak CSFeedItemContainerViewController *self, NSSet *old, NSSet *new) {
                  NSMutableArray *addedFeeds = [[new allObjects] mutableCopy];
                  NSMutableArray *removedFeeds = [[old allObjects] mutableCopy];
                  
                  [addedFeeds removeObjectsInArray:[old allObjects]];
                  [removedFeeds removeObjectsInArray:[new allObjects]];
                  
                  for ( Feed *feed in removedFeeds ){
                    [feed removeAllObservations];
                  }
                  
                  for ( Feed *feed in addedFeeds ){
                    [feed observeRelationship:@"feedItems"
                                  changeBlock:^(__weak Feed *feed, NSSet *new, NSSet *old) {
                                    NSMutableArray *addedFeedItems;
                                    NSMutableArray *removedFeedItems;
                                    
                                    if( new != nil ){
                                      addedFeedItems = [[new allObjects] mutableCopy];
                                      removedFeedItems = [[old allObjects] mutableCopy];
                                      
                                      [addedFeedItems removeObjectsInArray:[old allObjects]];
                                      [removedFeedItems removeObjectsInArray:[new allObjects]];
                                    } else {
                                      addedFeedItems = [[old allObjects] mutableCopy];
                                      removedFeedItems = [[new allObjects] mutableCopy];
                                    }
                                    
                                    for ( FeedItem *item in removedFeedItems ){
                                      [item removeAllObservations];
                                    }
                                    
                                    
                                    for ( FeedItem *item in addedFeedItems ){
                                      [_feedItemsSet addObject:item];
                                    }
                                    
                                      [scrollViewDelegate populateFeeds:_feedItemsSet];
                                  }
                               insertionBlock:nil
                                 removalBlock:nil
                             replacementBlock:nil];
                  }
                  
                  //properties:@[@"title", @"summary", @"updatedAt", @"publishedAt", @"createdAt", @"image", @"url"]
                }
             insertionBlock:nil
               removalBlock:nil
           replacementBlock:nil
   ];
  
}

@end
