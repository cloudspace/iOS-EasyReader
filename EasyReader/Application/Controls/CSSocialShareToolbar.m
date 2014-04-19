//
//  EZRSocialShareToolbar.m
//  EasyReader
//
//  Created by Joseph Lorich on 4/18/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import "CSSocialShareToolbar.h"


@interface CSSocialShareToolbar ()

@property (nonatomic, retain) NSString *shareText;
@property (nonatomic, retain) UIImage *shareImage;
@property (nonatomic, retain) NSURL *shareURL;

@end

@implementation CSSocialShareToolbar
{
    /// Background gradient
    CAGradientLayer *gradient;
    
    /// The share via mail button
    UIBarButtonItem *button_shareMail;
    
    /// The share via facebook button
    UIBarButtonItem *button_shareFacebook;
    
    /// The share via twitter button
    UIBarButtonItem *button_shareTwitter;
    
    /// The mail compose view controller
    MFMailComposeViewController *mailComposeViewContoller;
}


- (NSString *)shareText {
    if ([self.dataSource respondsToSelector:@selector(socialToolbar:textForShareDialogFromService:)]) {
        return [self.dataSource socialToolbar:self textForShareDialogFromService:SLServiceTypeFacebook];
    }
    
    return nil;
}
///**
// * A memoized accessor to shareImage
// */
//- (UIImage *)shareImage {
//    if (!_shareImage && [self.dataSource respondsToSelector:@selector(socialToolbar:imageForShareDialogFromService:)]) {
//        _shareImage = [self.dataSource socialToolbar:self imageForShareDialogFromService:SLServiceTypeFacebook];
//        
//        if (!_shareImage) {
//            _shareImage = (UIImage *)[NSNull null];
//        }
//    }
//    
//    if ([_shareImage isKindOfClass:[NSNull class]]) {
//        return nil;
//    }
//    
//    return _shareImage;
//}


- (UIImage *)shareImage {
    if ([self.dataSource respondsToSelector:@selector(socialToolbar:imageForShareDialogFromService:)]) {
        return [self.dataSource socialToolbar:self imageForShareDialogFromService:SLServiceTypeFacebook];
    }
    
    return nil;
}

- (NSURL *)shareURL {
    if (!_shareURL && [self.dataSource respondsToSelector:@selector(socialToolbar:urlForShareDialogFromService:)]) {
        return [self.dataSource socialToolbar:self urlForShareDialogFromService:SLServiceTypeFacebook];
    }
    
    return nil;
}




- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        button_shareMail = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_shareMail"]
                                                            style:UIBarButtonItemStylePlain
                                                           target:self
                                                           action:@selector(shareWithMail)];
        
        button_shareTwitter = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_shareTwitter"]
                                                               style:UIBarButtonItemStylePlain
                                                              target:self
                                                              action:@selector(shareWithTwitter)];
        
        button_shareFacebook = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_shareFacebook"]
                                                                style:UIBarButtonItemStylePlain
                                                               target:self
                                                               action:@selector(shareWithFacebook)];
        
        button_shareMail.tintColor = [UIColor whiteColor];
        button_shareTwitter.tintColor = [UIColor whiteColor];
        button_shareFacebook.tintColor = [UIColor whiteColor];
        
        UIBarButtonItem *flexSpace1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *flexSpace2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *flexSpace3 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *flexSpace4 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        self.items = @[
                         flexSpace1,
                         button_shareMail,
                         flexSpace2,
                         button_shareTwitter,
                         flexSpace3,
                         button_shareFacebook,
                         flexSpace4
                     ];
        
        self.barStyle = UIBarStyleBlack;
        self.translucent = YES;
        
        UIColor *fromColor = [UIColor colorWithRed:59.0/255.0f green:57.0/255.0f blue:57.0/255.0f alpha:1.0f];
        UIColor *toColor = [UIColor colorWithRed:43.0/255.0f green:42.0/255.0f blue:42.0/255.0f alpha:1.0f];
        
        gradient = [CAGradientLayer layer];
        gradient.colors = [NSArray arrayWithObjects:(id)[toColor CGColor], (id)[fromColor CGColor], nil];
        [self.layer insertSublayer:gradient atIndex:0];
        
    }
    return self;
}


- (void) layoutSubviews
{
    [super layoutSubviews];
    
    gradient.frame = self.bounds;
}


/**
 * Triggers the didSelectShareWithMailFromToolbar on the delegate if it responds
 */
- (void)shareWithMail {
    UIViewController *presentingController = [self.dataSource containingViewControllerForDialogFromSocialToolbar:self];
    
    mailComposeViewContoller = [[MFMailComposeViewController alloc] init];
    mailComposeViewContoller.mailComposeDelegate = self;
    
    [mailComposeViewContoller setSubject:self.shareText];

    
    NSMutableString *messageBody = [[NSMutableString alloc] init];

    [messageBody appendString:@"<html><body><p>"];

    if (self.shareURL) {
        [messageBody appendString:[self.shareURL absoluteString]];
    }

    [messageBody appendString:@"</p></body></html>"];
    
    if (self.shareImage) {
        NSData *jpegData = UIImageJPEGRepresentation(self.shareImage, 1);
        
        NSString *fileName = @"attachment";
        fileName = [fileName stringByAppendingPathExtension:@"jpeg"];
        [mailComposeViewContoller addAttachmentData:jpegData mimeType:@"image/jpeg" fileName:fileName];
    }
    
    [mailComposeViewContoller setMessageBody:messageBody isHTML:YES];
    
    [presentingController presentViewController:mailComposeViewContoller animated:YES completion:nil];
}


- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    UIViewController *presentingController = [self.dataSource containingViewControllerForDialogFromSocialToolbar:self];
    
    [presentingController dismissViewControllerAnimated:YES completion:nil];
}

/**
 * Triggers the didSelectShareWithTwitterFromToolbar on the delegate if it responds
 */
- (void)shareWithTwitter {
    UIViewController *presentingController = [self.dataSource containingViewControllerForDialogFromSocialToolbar:self];
    SLComposeViewController *twitterComposeViewController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    
    [twitterComposeViewController setInitialText:self.shareText];
    [twitterComposeViewController addImage:self.shareImage];
    [twitterComposeViewController addURL:self.shareURL];
    
    [presentingController presentViewController:twitterComposeViewController animated:YES completion:nil];
}

/**
 * Triggers the didSelectShareWithFacebookFromToolbar on the delegate if it responds
 */
- (void)shareWithFacebook {
    UIViewController *presentingController = [self.dataSource containingViewControllerForDialogFromSocialToolbar:self];
    SLComposeViewController *facebookComposeViewController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    
    [facebookComposeViewController setInitialText:self.shareText];
    [facebookComposeViewController addImage:self.shareImage];
    [facebookComposeViewController addURL:self.shareURL];
    
    [presentingController presentViewController:facebookComposeViewController animated:YES completion:nil];
}

@end
