//
//  CSFeedItemViewController.h
//  EasyReader
//
//  Created by Joseph Lorich on 4/9/13.
//  Copyright (c) 2013 Cloudspace. All rights reserved.
//

#import "CSBaseViewController.h"
#import <iAd/iAd.h>


@interface CSFeedItemViewController : CSBaseViewController <UIActionSheetDelegate, UIWebViewDelegate, ADBannerViewDelegate>


#pragma mark - IBOutlet Properties
@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *busyWebIcon;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *webForward;
@property (nonatomic, retain) IBOutlet UIToolbar *toolBar;
@property (nonatomic, retain) IBOutlet ADBannerView *adView;

- (void) showNoNetworkAlert;
- (IBAction) browseBack: (id) sender;
- (IBAction) browseForward: (id) sender;
- (IBAction) stopOrReLoadWeb: (id) sender;
- (IBAction) launchSafari: (id) sender;
- (void) loadBrowser: (NSURL *) url;


@end
