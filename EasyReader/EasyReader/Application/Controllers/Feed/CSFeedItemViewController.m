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

- (void) loadBrowser: (NSURL *) url
{
  self.webView.delegate = self;
  
  [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
  
  // Disable forward button
  self.webForward.enabled = NO;
}

- (IBAction) browseBack: (id) sender
{
	if ([self.webView canGoBack]){
		[self.webView goBack];
		// Enable the forward button
		self.webForward.enabled = YES;
	}else{
		[self done:nil];
	}
	
}

- (IBAction) browseForward: (id) sender
{
	if ([self.webView canGoForward]){
		[self.webView goForward];
		
		if (![self.webView canGoForward]){
			// disable the forward button
			self.webForward.enabled = NO;
		}
	}else{
		self.webForward.enabled = NO;
	}
	
}

- (IBAction) stopOrReLoadWeb: (id) sender
{
	// NOTE: stop is not implemented.  Only reload is implemented.
	/*
	 if ([webView isLoading]){
	 [webView stopLoading];
	 }else*/{
		 [self.webView reload];
	 }
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 0){
		[[UIApplication sharedApplication] openURL:[[self.webView request] URL]];
	}
	
}

- (IBAction) launchSafari: (id) sender{
	
	UIActionSheet *menu = [[UIActionSheet alloc]
                         initWithTitle: nil
                         delegate:self
                         cancelButtonTitle:@"Cancel"
                         destructiveButtonTitle:nil
                         otherButtonTitles:@"View in Safari", nil];
	[menu showFromToolbar:self.toolBar];
}



- (void) showNoNetworkAlert
{
	UIAlertView *baseAlert = [[UIAlertView alloc]
                            initWithTitle:@"No Network" message:@"A network connection is required.  Please verifiy your network settings and try again."
                            delegate:nil cancelButtonTitle:nil
                            otherButtonTitles:@"OK", nil];
	[baseAlert show];
}

//
#pragma mark UIWebView delegate methods
//

- (void)webViewDidStartLoad:(UIWebView *)webView
{
  // starting the load, show the activity indicator in the status bar
  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView1
{
  // finished loading, hide the activity indicator
  [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
	
	if (![webView1 canGoForward]){
		// disable the forward button
		self.webForward.enabled = NO;
	}
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
  // load error, hide the activity indicator in the status bar
  [MBProgressHUD hideAllHUDsForView:webView animated:YES];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
	return YES;
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  // We support any orientation
  return (YES);
}


- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
  // Release anything that's not essential, such as cached data
}

-(IBAction)back: (id)sender
{
	//  If we go back past the first web page in the cache, then dismiss the web view
	
	if ([self.webView canGoBack]){
		[self.webView goBack];
	}else{
		[self done:nil];
	}
}

-(IBAction)done: (id)sender
{
  [self dismissViewControllerAnimated:YES completion:^{
    
  }];
}

- (void)viewDidLoad
{
  [self.toolBar setBarStyle:UIBarStyleBlackOpaque];
  [self.toolBar setTintColor:[UIColor blackColor]];
}

- (void)viewWillDisappear:(BOOL)animated
{
  [self.webView stopLoading];
  self.webView = NULL;
}

#pragma mark - iAD

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
  if (!willLeave)
  {
    // insert code here to suspend any services that might conflict with the advertisement
  }
  return YES;
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
	self.adView.hidden = YES;
//  [self.webView setFrame:CGRectMake(
//    self.webView.frame.origin.x,
//    self.webView.frame.origin.y,
//    self.webView.frame.size.width,
//    self.webView.frame.size.height + self.adView.frame.size.height
//  )];
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
  self.adView.hidden = NO;
  [self.webView setFrame:CGRectMake(
    self.webView.frame.origin.x,
    self.webView.frame.origin.y,
    self.webView.frame.size.width,
    self.webView.frame.size.height - self.adView.frame.size.height
  )];
}
@end
