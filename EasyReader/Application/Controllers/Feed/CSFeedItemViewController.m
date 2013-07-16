//
//  CSFeedItemViewController.m
//  EasyReader
//
//  Created by Joseph Lorich on 4/9/13.
//  Copyright (c) 2013 Cloudspace. All rights reserved.
//
#import <Social/Social.h>
#import <MessageUI/MessageUI.h>

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
                                                                    action:@selector(share:)];
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
 * Shows a UIActionSheet with the option to view in safari
 */
- (void) share: (id) sender{
	
	UIActionSheet *menu = [[UIActionSheet alloc]
                         initWithTitle: nil
                         delegate:self
                         cancelButtonTitle:@"Cancel"
                         destructiveButtonTitle:nil
                         otherButtonTitles:@"View in Safari", @"Share via Mail", @"Share on Facebook", @"Share on Twitter", nil];
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


#pragma mark - UIActionSheetDelegate Methods
/**
 * Launches safari with the curren tURL
 */
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
  switch (buttonIndex)
  {
    case 0: //Open in safari
      if (self.destinationUrl)
      {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.destinationUrl]];
      }
      break;
    case 1: // Mail
    {
      [MBProgressHUD showHUDAddedTo:self.view animated:YES];
      
      dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
        
        mailController.mailComposeDelegate = self;
        
        [mailController setSubject:@"Check out this article!"];
        NSString *messageBody = @"";
        if (self.destinationUrl)
        {
          messageBody = [messageBody stringByAppendingString:@"<a href=\""];
          messageBody = [messageBody stringByAppendingString:self.destinationUrl];
          messageBody = [messageBody stringByAppendingString:@"\">"];
          messageBody = [messageBody stringByAppendingString:self.destinationUrl];
          messageBody = [messageBody stringByAppendingString:@"</a><br /><br /> Discovered with Easy Reader for iOS by Cloudspace!"];
        }
        
        [mailController setMessageBody:messageBody isHTML:YES];
        
        dispatch_async(dispatch_get_main_queue(), ^{
          [MBProgressHUD hideHUDForView:self.view animated:YES];
          [self presentViewController:mailController animated:YES completion:nil];
        });
      });

      break;
    }
    case 2: //Facebook
    {
      [MBProgressHUD showHUDAddedTo:self.view animated:YES];
      
      if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
      {
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
          SLComposeViewController *fbController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
          
          SLComposeViewControllerCompletionHandler __block completionHandler=^(SLComposeViewControllerResult result){
            
            [fbController dismissViewControllerAnimated:YES completion:nil];
            
            switch(result){
              case SLComposeViewControllerResultCancelled:
              default:
              {
                NSLog(@"Cancelled.....");
                
              }
                break;
              case SLComposeViewControllerResultDone:
              {
                [[[UIAlertView alloc] initWithTitle:@"Posted!"
                                            message:@"This article has successfully been posted to Facebook."
                                           delegate:nil
                                  cancelButtonTitle:nil
                                  otherButtonTitles:@"Thanks!", nil
                  ] show];
              }
                break;
            }};
          if (self.destinationUrl)
          {
            [fbController addURL:[NSURL URLWithString:self.destinationUrl]];
          }
          
          [fbController setInitialText:@"Discovered with Easy Reader for iOS by Cloudspace!"];
          [fbController setCompletionHandler:completionHandler];
          
          dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self presentViewController:fbController animated:YES completion:nil];
          });
        });
      }
      else
      {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [[[UIAlertView alloc] initWithTitle:@"Oops!"
                                    message:@"It looks like Facebook integration isn't set up on this device.  You can enable it in your device settings."
                                   delegate:nil
                          cancelButtonTitle:nil
                          otherButtonTitles:@"Okay!", nil
          ] show];
      }
      
      break;
    }
    case 3: //Twitter
    {
      [MBProgressHUD showHUDAddedTo:self.view animated:YES];
      
      if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
      {
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
          SLComposeViewController *twitterController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
          
          SLComposeViewControllerCompletionHandler __block completionHandler=^(SLComposeViewControllerResult result){
            
            [twitterController dismissViewControllerAnimated:YES completion:nil];
            
            switch(result){
              case SLComposeViewControllerResultCancelled:
              default:
              {
                NSLog(@"Tweet Cancelled");
                
              }
                break;
              case SLComposeViewControllerResultDone:
              {
                [[[UIAlertView alloc] initWithTitle:@"Posted!"
                                            message:@"This article has successfully been posted to Twitter."
                                           delegate:nil
                                  cancelButtonTitle:nil
                                  otherButtonTitles:@"Thanks!", nil
                  ] show];
              }
                break;
            }};
          
          if (self.destinationUrl)
            [twitterController addURL:[NSURL URLWithString:self.destinationUrl]];
          
          [twitterController setInitialText:@"Discovered with Easy Reader for iOS by Cloudspace!"];
          [twitterController setCompletionHandler:completionHandler];
          
          dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self presentViewController:twitterController animated:YES completion:nil];
          });
        });
      }
      else
      {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [[[UIAlertView alloc] initWithTitle:@"Oops!"
                                    message:@"It looks like Twitter integration isn't set up on this device.  You can enable it in your device settings."
                                   delegate:nil
                          cancelButtonTitle:nil
                          otherButtonTitles:@"Okay!", nil
          ] show];
      }
      break;
    }
  }
}

#pragma mark - MFMailComposeViewController Delegate Methods
/*!
 * Dismisses the mail view on completion
 */
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
  [self dismissViewControllerAnimated:YES completion:nil];
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
