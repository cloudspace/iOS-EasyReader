//
//  CSFeedCollectionViewController.m
//  EasyReader
//
//  Created by Joseph Lorich on 3/13/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import "CSFeedCollectionViewController.h"
#import "FeedCollectionViewDataSource.h"
#import "FeedItem.h"
#import "CSFeedItemCell.h"
#import "Feed.h"

@interface CSFeedCollectionViewController ()

/// The collection view which holds the individual feed items
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView_feedItems;

@end


@implementation CSFeedCollectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self setUpCollectionView];
    // Do any additional setup after loading the view.
}

- (void)setUpCollectionView
{
    NSArray *feedItems = [FeedItem MR_findAll];
    
    FeedCollectionViewDataSource *feedCollectionViewDataSource =
        [[FeedCollectionViewDataSource alloc] initWithFeedItems:feedItems
                                         reusableCellIdentifier:@"feedItemCell"
                                                 configureBlock:[self configureFeedItem]];
    
    self.collectionView_feedItems.dataSource = feedCollectionViewDataSource;
    
}

- (configureFeedItemCell)configureFeedItem
{
    return ^void(CSFeedItemCell *cell, FeedItem *feedItem) {
        cell.label_headline.text = feedItem.title;
        cell.label_source.text = feedItem.feed.name;
    };
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
