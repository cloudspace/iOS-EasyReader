//
//  CSFeedCollectionViewController.m
//  EasyReader
//
//  Created by Joseph Lorich on 3/13/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import "CSHomeViewController.h"
#import <Block-KVO/MTKObserving.h>
#import "CSFeedItemCollectionView.h"
#import "CSFeedItemCollectionViewDataSource.h"
#import "FeedItem.h"
#import "MFSideMenu.h"
#import "CSFeedItemCell.h"
#import "Feed.h"
#import "User.h"

@interface CSHomeViewController (){
  NSString *currentURL;
}

/// The collection view which holds the individual feed items
@property (nonatomic, weak) IBOutlet CSFeedItemCollectionView *collectionView_feedItems;

@end


@implementation CSHomeViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  _feedItems = [[NSMutableSet alloc] init];
  [_pageControl_itemIndicator setUpFadesOnView:[_pageControl_itemIndicator superview]];
  _pageControl_itemIndicator.controller_owner = self;
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
                changeBlock:^(__weak CSHomeViewController *self, NSSet *old, NSSet *new) {
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
                                        
                                        _feedItems = [(CSFeedItemCollectionViewDataSource *)_collectionView_feedItems.dataSource feedItems];
                                        
                                        if(!new) {
                                          NSLog(@"There are no feeds here");
                                        } else {
                                          NSMutableArray *addedFeedItems = [[new allObjects] mutableCopy];
                                          NSMutableArray *removedFeedItems = [[old allObjects] mutableCopy];
                                          
                                          [addedFeedItems removeObjectsInArray:[old allObjects]];
                                          [removedFeedItems removeObjectsInArray:[new allObjects]];
                                          
                                          for( FeedItem *item in removedFeedItems ){
                                            [_feedItems removeObject:item];
                                          }
                                          
                                          for( FeedItem *item in addedFeedItems ){
                                            [_feedItems addObject:item];
                                          }
                                          
                                          [_pageControl_itemIndicator.button_newItem setHidden:NO];
                                        }
                                        
                                        //redraw the collection with the changes to the feed items
                                        [_feedCollectionViewDataSource sortFeedItems];
                                        [_collectionView_feedItems reloadData];
                                        _pageControl_itemIndicator.numberOfPages = [_feedItems count] < 6 ? [_feedItems count] : 5;
                                        
                                        if(_currentFeedItem){
                                          [self scrollToCurrentFeedItem];
                                          [_pageControl_itemIndicator setPageControllerPageAtIndex:[_feedCollectionViewDataSource.sortedFeedItems indexOfObject:_currentFeedItem]
                                                                                     forCollection:_feedItems];
                                        } else {
                                          [_pageControl_itemIndicator setPageControllerPageAtIndex:0 forCollection:_feedItems];
                                        }
                                      }
                                   insertionBlock:nil
                                     removalBlock:nil
                                 replacementBlock:nil];
                    }
                }
             insertionBlock:nil
               removalBlock:nil
           replacementBlock:nil
   ];
  NSLog(@"observer added");
}

// Sets up collection view on controller start up
- (void)setUpCollectionView
{
  User *current = [User current];
  NSSet *feedItems = current.feedItems;

  _feedCollectionViewDataSource =
      [[CSFeedItemCollectionViewDataSource alloc] initWithFeedItems:feedItems
                                       reusableCellIdentifier:@"feedItemCell"
                                               configureBlock:[self configureFeedItem]];
  
  self.collectionView_feedItems.dataSource = _feedCollectionViewDataSource;
  self.collectionView_feedItems.delegate = self;
  
  
}

#pragma mark - IBActions

// Receives left menu link click
- (IBAction)buttonLeftMenu_touchUpInside_goToMenu:(id)sender {
  [[self rootViewController] toggleLeftSideMenuCompletion:^{}];
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
        if(_currentFeedItem != self.collectionView_feedItems.currentFeedItem){
            _currentFeedItem = self.collectionView_feedItems.currentFeedItem;
            [self.feedItemWebView loadHTMLString:@"<html><head></head><body></body></html>" baseURL:nil];
        }
    }
}

// Scroll to the currentFeedItem when the feedItems update
- (void)scrollToCurrentFeedItem
{
    NSUInteger index = [_feedCollectionViewDataSource.sortedFeedItems indexOfObject:_currentFeedItem];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [_collectionView_feedItems scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
}


- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
  int newIndex = indexPath.row+((indexPath.row-self.collectionCellGoingTo)*-1);
  [_pageControl_itemIndicator setPageControllerPageAtIndex:newIndex
                                             forCollection:_feedItems];
}

- (void)loadFeedItemWebView
{
    // Check if this is a new url
    if(currentURL != self.collectionView_feedItems.currentFeedItem.url){
        // update the current url
        currentURL = self.collectionView_feedItems.currentFeedItem.url;
        
        // load the url in the webView
        NSURL *url = [NSURL URLWithString:currentURL];
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
