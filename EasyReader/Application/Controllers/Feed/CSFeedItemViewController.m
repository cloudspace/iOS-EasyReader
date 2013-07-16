//
//  CSFeedItemViewController.m
//  EasyReader
//
//  Created by Joseph Lorich on 4/9/13.
//  Copyright (c) 2013 Cloudspace. All rights reserved.
//
#import "MBProgressHUD.h"
#import "CSFeedItemViewController.h"


@interface CSFeedItemViewController ()

@end

@implementation CSFeedItemViewController

/**
 * Sets up the toolbar on load
 */
- (void)viewDidLoad
{
  [super viewDidLoad];
  _barButton_action = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                    target:self
                                                                    action:@selector(launchSafari:)];
  self.webView.delegate = self;
  self.navigationItem.rightBarButtonItem = _barButton_action;
}

/**
 * Stops loading when the view disappears
 */
- (void)viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
  
  [self.webView stopLoading];
  self.webView = NULL;
}

/**
 * Launches safari with the curren tURL
 */
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 0 && self.destinationUrl){
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.destinationUrl]];
	}
	
}

/**
 * Shows a UIActionSheet with the option to view in safari
 */
- (void) launchSafari: (id) sender{
	
	UIActionSheet *menu = [[UIActionSheet alloc]
                         initWithTitle: nil
                         delegate:self
                         cancelButtonTitle:@"Cancel"
                         destructiveButtonTitle:nil
                         otherButtonTitles:@"View in Safari", nil];
  [menu showInView:self.view];
}

/**
 * Shows an alert when no network connection is available
 */
- (void) showNoNetworkAlert
{
	UIAlertView *baseAlert = [[UIAlertView alloc]
                            initWithTitle:@"No Network" message:@"A network connection is required.  Please verifiy your network settings and try again."
                            delegate:nil cancelButtonTitle:nil
                            otherButtonTitles:@"OK", nil];
	[baseAlert show];
}


#pragma mark - UIWebView delegate methods
/**
 * Shows a loading indicatior on load start
 */
- (void)webViewDidStartLoad:(UIWebView *)webView
{
  // starting the load, show the activity indicator in the status bar
  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}


/**
 * Removes the loading indicator on load finish
 */
- (void)webViewDidFinishLoad:(UIWebView *)webView1
{
  // finished loading, hide the activity indicator
  [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

/**
 * Hides the loading indicator on fail with error
 */
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
  // load error, hide the activity indicator in the status bar
  [MBProgressHUD hideAllHUDsForView:webView animated:YES];
}

/**
 * Determines if the webview should start loading a request
 */
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
	return YES;
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  // We support any orientation
  return (YES);
}


#pragma mark - iAD
/**
 *
 */
- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
  if (!willLeave)
  {
    // insert code here to suspend any services that might conflict with the advertisement
  }
  return YES;
}

/**
 * Hides the banner ad when an error occurs loading it
 */
- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
  NSLog(@"Failed to load iAD: %@", error.localizedDescription);
  
	self.adView.hidden = YES;
//  [self.webView setFrame:CGRectMake(
//    self.webView.frame.origin.x,
//    self.webView.frame.origin.y,
//    self.webView.frame.size.width,
//    self.webView.frame.size.height + self.adView.frame.size.height
//  )];
}

/**
 * Shows the banner ad when an ad successfully loads
 */
- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
  NSLog(@"Successfully loaded iAD");
  
  self.adView.hidden = NO;
  [self.webView setFrame:CGRectMake(
    self.webView.frame.origin.x,
    self.webView.frame.origin.y,
    self.webView.frame.size.width,
    self.webView.frame.size.height - self.adView.frame.size.height
  )];
}

@end
