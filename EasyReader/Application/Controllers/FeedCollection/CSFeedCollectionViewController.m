//
//  CSFeedCollectionViewController.m
//  EasyReader
//
//  Created by Joseph Lorich on 3/13/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import "CSFeedCollectionViewController.h"
#import "CSFeedItemCollectionView.h"
#import "FeedCollectionViewDataSource.h"
#import "FeedItem.h"
#import "CSFeedItemCell.h"
#import "Feed.h"

@interface CSFeedCollectionViewController (){
    FeedCollectionViewDataSource *feedCollectionViewDataSource;
}

/// The collection view which holds the individual feed items
@property (nonatomic, weak) IBOutlet CSFeedItemCollectionView *collectionView_feedItems;

@end


@implementation CSFeedCollectionViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self setUpCollectionView];
    // Do any additional setup after loading the view.
}

- (void)setUpCollectionView
{
    NSArray *feedItems = [FeedItem MR_findAll];
    
    feedCollectionViewDataSource =
        [[FeedCollectionViewDataSource alloc] initWithFeedItems:feedItems
                                         reusableCellIdentifier:@"feedItemCell"
                                                 configureBlock:[self configureFeedItem]];
    
    self.collectionView_feedItems.dataSource = feedCollectionViewDataSource;
    self.collectionView_feedItems.delegate = self;
}

- (configureFeedItemCell)configureFeedItem
{
    return ^void(CSFeedItemCell *cell, FeedItem *feedItem) {
        cell.label_headline.text = feedItem.title;
        cell.label_source.text = feedItem.feed.name;
        cell.feedItem = feedItem;
    };
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
