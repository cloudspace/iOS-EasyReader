//
//  CSFeedCollectionViewController.m
//  EasyReader
//
//  Created by Joseph Lorich on 3/13/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import "CSFeedCollectionViewController.h"
#import <Block-KVO/MTKObserving.h>
#import "CSFeedItemCollectionView.h"
#import "FeedCollectionViewDataSource.h"
#import "FeedCollectionViewDataSource.h"
#import "FeedItem.h"
#import "CSFeedItemCell.h"
#import "Feed.h"
#import "User.h"

@interface CSFeedCollectionViewController (){
    FeedCollectionViewDataSource *feedCollectionViewDataSource;
    FeedItem *currentFeedItem;
}

/// The collection view which holds the individual feed items
@property (nonatomic, weak) IBOutlet CSFeedItemCollectionView *collectionView_feedItems;

@end


@implementation CSFeedCollectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpCollectionView];
    [self setUpWebView];
    [self setupFeedItemObserver];
    // Do any additional setup after loading the view.
}

- (void)viewDidLayoutSubviews
{
    [self setUpVerticalScrollView];
}

- (void) setupFeedItemObserver
{
    _currentUser = [User current];
    [self observeRelationship:@keypath(self.currentUser.feeds)
                  changeBlock:^(__weak CSFeedCollectionViewController *self, NSSet *old, NSSet *new) {
                      NSMutableArray *addedFeeds = [[new allObjects] mutableCopy];
                      NSMutableArray *removedFeeds = [[old allObjects] mutableCopy];
                      
                      
                      [addedFeeds removeObjectsInArray:[old allObjects]];
                      [removedFeeds removeObjectsInArray:[new allObjects]];
                      
                      for ( Feed *feed in removedFeeds ){
                          [feed removeAllObservations];
                      }
                      
                      for ( Feed *feed in addedFeeds ){
                          [feed observeRelationship:@"feedItems"
                                        changeBlock:^(__weak Feed *feed, NSSet *old, NSSet *new) {
                                            if([old  count] > 0 && [new count] <= 0) {
                                                [(FeedCollectionViewDataSource *)_collectionView_feedItems.dataSource setFeedItems:[[old allObjects] mutableCopy]];
                                                
                                                //redraw the collection with the changes to the feed items
                                                [_collectionView_feedItems reloadData];
                                            } else if([new count] > 0) {
                                                [(FeedCollectionViewDataSource *)_collectionView_feedItems.dataSource setFeedItems:[[new allObjects] mutableCopy]];
                                            
                                                //redraw the collection with the changes to the feed items
                                                [_collectionView_feedItems reloadData];
                                            }
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
        cell.label_source.text = feedItem.headline;
        cell.label_summary.text = feedItem.summary;
        cell.feedItem = feedItem;
    };
}

-(void)setUpVerticalScrollView{
    // Set contentSize to be twice the height of the scrollview
    NSInteger width = self.verticalScrollView.frame.size.width;
    NSInteger height = self.verticalScrollView.frame.size.height;
    self.verticalScrollView.contentSize = CGSizeMake(width, height*2);
    
    self.verticalScrollView.pagingEnabled =YES;
    self.verticalScrollView.delegate = self;
}

-(void)setUpWebView
{
    // Create a new webview and place it below the collectionView
    self.feedItemWebView = [[UIWebView alloc] init];
    NSInteger width = self.verticalScrollView.frame.size.width;
    NSInteger height = self.verticalScrollView.frame.size.height;
    self.feedItemWebView.frame= CGRectMake(0, height, width, height*2);

    // Add it to the bottom of the scrollView
    [self.verticalScrollView addSubview:self.feedItemWebView];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)sender {
    // If we are scrolling in the scrollView only not a subclass
    if([sender isMemberOfClass:[UIScrollView class]]) {
        [self loadFeedItemWebView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)sender {
    // If we are scrolling in the collectionView only
    if([sender isMemberOfClass:[CSFeedItemCollectionView class]]) {
        
        // unload the webView if we have moved to a new feedItem
        if(currentFeedItem != self.collectionView_feedItems.currentFeedItem){
            [self.feedItemWebView loadHTMLString:@"<html><head></head><body></body></html>" baseURL:nil];
        }
    }
}

-(void)loadFeedItemWebView
{
    // Check if this is a new url
    if(currentFeedItem != self.collectionView_feedItems.currentFeedItem){
        // update the current url
        currentFeedItem = self.collectionView_feedItems.currentFeedItem;
        
        // load the url in the webView
        NSURL *url = [NSURL URLWithString:self.collectionView_feedItems.currentFeedItem.url];
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
        [self.feedItemWebView loadRequest:requestObj];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
