//
//  EZRSocialShareToolbar.m
//  EasyReader
//
//  Created by Joseph Lorich on 4/18/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import "CLDSocialShareToolbar.h"

typedef void (^CLDSocialCompletionBlock)(SLComposeViewControllerResult result);

@interface CLDSocialShareToolbar ()
{
    /// The share text from the dataSource
    NSString *_shareText;
    
    /// The share image from the dataSource
    UIImage *_shareImage;
    
    /// The share URL from the dataSource
    NSURL *_shareURL;
}

/// The share via mail button
@property (nonatomic, retain) UIBarButtonItem *button_shareMail;

/// The share via facebook button
@property (nonatomic, retain) UIBarButtonItem *button_shareFacebook;

/// The share via twitter button
@property (nonatomic, retain) UIBarButtonItem *button_shareTwitter;

/// The mail compose view controller
@property (nonatomic, retain) MFMailComposeViewController *mailComposeViewContoller;


@end


@implementation CLDSocialShareToolbar

#pragma mark - Initializers

/**
 * Sets up the sharing toolbar
 */
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.button_shareMail = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_shareMail"]
                                                            style:UIBarButtonItemStylePlain
                                                           target:self
                                                           action:@selector(shareWithMail)];
        
        self.button_shareTwitter = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_shareTwitter"]
                                                               style:UIBarButtonItemStylePlain
                                                              target:self
                                                              action:@selector(shareWithTwitter)];
        
        self.button_shareFacebook = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_shareFacebook"]
                                                                style:UIBarButtonItemStylePlain
                                                               target:self
                                                               action:@selector(shareWithFacebook)];
        
        self.button_shareMail.tintColor = [UIColor whiteColor];
        self.button_shareTwitter.tintColor = [UIColor whiteColor];
        self.button_shareFacebook.tintColor = [UIColor whiteColor];
        self.label_title = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 30)];
        self.label_title.text = @"Share with:";
        self.label_title.textColor = [UIColor whiteColor];
        
        UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        UIBarButtonItem *smallSpace1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        smallSpace1.width = 10.0f;
        
        UIBarButtonItem *smallSpace2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        smallSpace2.width = 10.0f;
        
        
        UIBarButtonItem *barButtonItem_title = [[UIBarButtonItem alloc] initWithCustomView:self.label_title];

        self.items = @[
                         barButtonItem_title,
                         flexSpace,
                         self.button_shareFacebook,
                         smallSpace1,
                         self.button_shareTwitter,
                         smallSpace2,
                         self.button_shareMail
                     ];

    }
    
    return self;
}


#pragma mark - Property methods

/**
 * Returns the dataSource share text if it provides it
 */
- (NSString *)shareText:(CLDSocialServiceType)serviceType {
    if ([self.dataSource respondsToSelector:@selector(socialToolbar:textForShareDialogFromService:)]) {
        return [self.dataSource socialToolbar:self textForShareDialogFromService:serviceType];
    }
    
    return nil;
}

/**
 * Returns the dataSource share image if it provides it
 */
- (UIImage *)shareImage:(CLDSocialServiceType)serviceType {
    if ([self.dataSource respondsToSelector:@selector(socialToolbar:imageForShareDialogFromService:)]) {
        return [self.dataSource socialToolbar:self imageForShareDialogFromService:serviceType];
    }
    
    return nil;
}

/**
 * Returns the dataSource share url if it provides it
 */
- (NSURL *)shareURL:(CLDSocialServiceType)serviceType {
    if (!_shareURL && [self.dataSource respondsToSelector:@selector(socialToolbar:urlForShareDialogFromService:)]) {
        return [self.dataSource socialToolbar:self urlForShareDialogFromService:serviceType];
    }
    
    return nil;
}

/**
 * Sets the background to transparent or not based on the given backgroundTransparent boolean
 *
 * @param backgroundTransparent Whether or not the background should be transparent
 */
- (void) setBackgroundTransparent:(BOOL)backgroundTransparent {
    _backgroundTransparent = backgroundTransparent;
    
    if (backgroundTransparent) {
        [self setBackgroundImage:[UIImage new]
              forToolbarPosition:UIToolbarPositionAny
                      barMetrics:UIBarMetricsDefault];
        
        [self setBackgroundColor:[UIColor clearColor]];
    } else {
        [self setBackgroundImage:nil forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
        [self setBarStyle:UIBarStyleDefault];
    }
}


#pragma mark - Button actions

/**
 * Triggers the didSelectShareWithMailFromToolbar on the delegate if it responds
 */
- (void)shareWithMail {
    UIViewController *presentingController = [self.dataSource containingViewControllerForDialogFromSocialToolbar:self];
    
    self.mailComposeViewContoller = [[MFMailComposeViewController alloc] init];
    self.mailComposeViewContoller.mailComposeDelegate = self;
    
    [self.mailComposeViewContoller setSubject:[self shareText:CLDServiceTypeMail]];

    
    NSMutableString *messageBody = [[NSMutableString alloc] init];

    [messageBody appendString:@"<html><body><p>"];

    if ([self shareURL:CLDServiceTypeMail]) {
        [messageBody appendString:[[self shareURL:CLDServiceTypeMail] absoluteString]];
    }

    [messageBody appendString:@"</p></body></html>"];
    
    if ([self shareImage:CLDServiceTypeMail]) {
        NSData *jpegData = UIImageJPEGRepresentation([self shareImage:CLDServiceTypeMail], 1);
        
        NSString *fileName = @"attachment";
        fileName = [fileName stringByAppendingPathExtension:@"jpeg"];
        [self.mailComposeViewContoller addAttachmentData:jpegData mimeType:@"image/jpeg" fileName:fileName];
    }
    
    [self.mailComposeViewContoller setMessageBody:messageBody isHTML:YES];
    
    [presentingController presentViewController:self.mailComposeViewContoller animated:YES completion:nil];
}

/**
 * Triggers the didSelectShareWithTwitterFromToolbar on the delegate if it responds
 */
- (void)shareWithTwitter {
    UIViewController *presentingController = [self.dataSource containingViewControllerForDialogFromSocialToolbar:self];
    SLComposeViewController *twitterComposeViewController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    
    [twitterComposeViewController setInitialText:[self shareText:CLDServiceTypeTwitter]];
    [twitterComposeViewController addImage:[self shareImage:CLDServiceTypeTwitter]];
    [twitterComposeViewController addURL:[self shareURL:CLDServiceTypeTwitter]];
    
    [twitterComposeViewController setCompletionHandler:[self socialCompletionForServiceType:CLDServiceTypeTwitter]];
    
    [presentingController presentViewController:twitterComposeViewController animated:YES completion:nil];
}

/**
 * Triggers the didSelectShareWithFacebookFromToolbar on the delegate if it responds
 */
- (void)shareWithFacebook {
    UIViewController *presentingController = [self.dataSource containingViewControllerForDialogFromSocialToolbar:self];
    SLComposeViewController *facebookComposeViewController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    
    [facebookComposeViewController setInitialText:[self shareText:CLDServiceTypeFacebook]];
    [facebookComposeViewController addImage:[self shareImage:CLDServiceTypeFacebook]];
    [facebookComposeViewController addURL:[self shareURL:CLDServiceTypeFacebook]];
    
    [facebookComposeViewController setCompletionHandler:[self socialCompletionForServiceType:CLDServiceTypeFacebook]];
    
    [presentingController presentViewController:facebookComposeViewController animated:YES completion:nil];
}


#pragma mark - Share completion
/**
 * Returns a block that when executed triggers the appropriate social toolbar delegate completion method
 */
- (CLDSocialCompletionBlock)socialCompletionForServiceType:(CLDSocialServiceType)serviceType {
    return ^(SLComposeViewControllerResult result) {
        if ([self.delegate respondsToSelector:@selector(socialToolbar:didCompleteShareWithService:success:)]) {
            [self.delegate socialToolbar:self
             didCompleteShareWithService:serviceType
                                 success:(result == SLComposeViewControllerResultDone)];
        }
    };
}


#pragma mark - MFMailComposeViewControllerDelegate Methods

/**
 * Handles dismissing the mail controller window
 */
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    UIViewController *presentingController = [self.dataSource containingViewControllerForDialogFromSocialToolbar:self];
    
    if (result == MFMailComposeResultSent) {
        [self socialCompletionForServiceType:CLDServiceTypeMail](SLComposeViewControllerResultDone);
    }
    
    [presentingController dismissViewControllerAnimated:YES completion:nil];
}

@end
