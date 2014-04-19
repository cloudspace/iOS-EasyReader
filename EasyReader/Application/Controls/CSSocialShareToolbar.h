//
//  EZRSocialShareToolbar.h
//  EasyReader
//
//  Created by Joseph Lorich on 4/18/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import <MessageUI/MessageUI.h>

/**
 * Returns the page count to be used in the page control
 */

@class CSSocialShareToolbar;


/**
 * This protocol represents the data source for the Social Share Toolbar control
 */
@protocol CSSocialShareToolbarDataSource <NSObject>

@required

/**
 * Returns the view controller to display share dialogs within
 *
 * @param toolbar The social share toolbar making the request
 */
- (UIViewController *)containingViewControllerForDialogFromSocialToolbar:(CSSocialShareToolbar *)toolbar;

@optional

/**
 * Returns a title to share with the given service
 *
 * @param toolbar The social share toolbar making the request
 * @param serviceType The service type requested for the share.  Possible values are defined in <Social/SLServiceTypes.h>
 */
- (NSString *)socialToolbar:(CSSocialShareToolbar *)toolbar textForShareDialogFromService:(NSString *)serviceType;

/**
 * Returns a url to share with the given service
 *
 * @param toolbar The social share toolbar making the request
 * @param serviceType The service type requested for the share.  Possible values are defined in <Social/SLServiceTypes.h>
 */
- (NSURL *)socialToolbar:(CSSocialShareToolbar *)toolbar urlForShareDialogFromService:(NSString *)serviceType;


/**
 * Returns an image to share with the given service
 *
 * @param toolbar The social share toolbar making the request
 * @param serviceType The service type requested for the share.  Possible values are defined in <Social/SLServiceTypes.h>
 */
- (UIImage *)socialToolbar:(CSSocialShareToolbar *)toolbar imageForShareDialogFromService:(NSString *)serviceType;

@end

/**
 * A social sharing UIToolbar implementation
 */
@interface CSSocialShareToolbar : UIToolbar <MFMailComposeViewControllerDelegate>


# pragma mark - Properties

/// The object that acts as the data source of the receiving social share toolbar
@property (nonatomic, assign) IBOutlet id<CSSocialShareToolbarDataSource> dataSource;


@end
