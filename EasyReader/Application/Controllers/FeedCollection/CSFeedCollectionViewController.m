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
    NSString *currentFeedItemURL;
}

/// The collection view which holds the individual feed items
@property (nonatomic, weak) IBOutlet CSFeedItemCollectionView *collectionView_feedItems;

@end


@implementation CSFeedCollectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpVerticalScrollView];
    [self setUpCollectionView];
    [self setUpWebView];
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
    
    // Add it to the top of the scrollView
    NSInteger width = self.collectionView_feedItems.frame.size.width;
    NSInteger height = self.collectionView_feedItems.frame.size.height;
    self.collectionView_feedItems.frame= CGRectMake(0, 0, width, height);
    [self.verticalScrollView addSubview:self.collectionView_feedItems];
}


- (configureFeedItemCell)configureFeedItem
{
    return ^void(CSFeedItemCell *cell, FeedItem *feedItem) {
        cell.label_headline.text = feedItem.title;
        cell.label_source.text = feedItem.getHeadline;
        cell.label_summary.text = feedItem.summary;
        cell.feedItem = feedItem;
    };
}

-(void)setUpVerticalScrollView{
    // Set contentSize to be twice the height of the scrollview
    NSInteger width = self.verticalScrollView.frame.size.width;
    NSInteger height = self.verticalScrollView.frame.size.height;
    NSLog(@"%f",self.collectionView_feedItems.frame.size.height);
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
    
    // Set the url to nothing
    currentFeedItemURL = @"";
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)sender {
    // If we are scrolling in the scrollView only not a subclass
    if([sender isMemberOfClass:[UIScrollView class]]) {
        [self loadFeedItemWebView];
    }
}

-(void)loadFeedItemWebView
{
    // Check if this is a new url
    if(currentFeedItemURL != self.collectionView_feedItems.currentFeedItem.url){
        // update the current url
        currentFeedItemURL = self.collectionView_feedItems.currentFeedItem.url;
        
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
