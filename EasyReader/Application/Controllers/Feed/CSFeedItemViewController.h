//
//  CSFeedItemViewController.h
//  EasyReader
//
//  Created by Joseph Lorich on 4/9/13.
//  Copyright (c) 2013 Cloudspace. All rights reserved.
//

#import "CSBaseViewController.h"
#import <iAd/iAd.h>
#import <MessageUI/MessageUI.h>

@interface CSFeedItemViewController : CSBaseViewController <
  UIActionSheetDelegate,
  UIWebViewDelegate,
  MFMailComposeViewControllerDelegate,
  ADBannerViewDelegate
>
{
  BOOL _adAvailable;
}


#pragma mark - IBOutlet Properties
@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) IBOutlet ADBannerView *adView;
@property (nonatomic, retain) IBOutlet NSLayoutConstraint *adViewBottomSpace;

#pragma mark - Properties

@property (nonatomic, retain) UIActivityIndicatorView *busyWebIcon;
@property (nonatomic, retain) UIBarButtonItem *barButton_action;
@property (nonatomic, retain) NSString *destinationUrl;



#pragma mark - Methods
- (void) showNoNetworkAlert;
//- (IBAction) browseBack: (id) sender;
//- (IBAction) browseForward: (id) sender;
//- (IBAction) stopOrReLoadWeb: (id) sender;
- (void) share: (id) sender;
//- (void) loadBrowser: (NSURL *) url;


@end
