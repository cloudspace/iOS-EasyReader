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


@class CLDSocialShareToolbar;

#pragma mark - CLDSocialShareToolbarDataSource

/**
 * This protocol represents the data source for the Social Share Toolbar control
 */
@protocol CLDSocialShareToolbarDataSource <NSObject>

@required

/**
 * Returns the view controller to display share dialogs within
 *
 * @param toolbar The social share toolbar making the request
 */
- (UIViewController *)containingViewControllerForDialogFromSocialToolbar:(CLDSocialShareToolbar *)toolbar;

@optional

/**
 * Returns a title to share with the given service
 *
 * @param toolbar The social share toolbar making the request
 * @param serviceType The service type requested for the share.  Possible values are defined in <Social/SLServiceTypes.h>
 */
- (NSString *)socialToolbar:(CLDSocialShareToolbar *)toolbar textForShareDialogFromService:(NSString *)serviceType;

/**
 * Returns a url to share with the given service
 *
 * @param toolbar The social share toolbar making the request
 * @param serviceType The service type requested for the share.  Possible values are defined in <Social/SLServiceTypes.h>
 */
- (NSURL *)socialToolbar:(CLDSocialShareToolbar *)toolbar urlForShareDialogFromService:(NSString *)serviceType;

/**
 * Returns an image to share with the given service
 *
 * @param toolbar The social share toolbar making the request
 * @param serviceType The service type requested for the share.  Possible values are defined in <Social/SLServiceTypes.h>
 */
- (UIImage *)socialToolbar:(CLDSocialShareToolbar *)toolbar imageForShareDialogFromService:(NSString *)serviceType;

@end


#pragma mark - CLDSocialShareToolbar

/**
 * A social sharing UIToolbar implementation
 */
@interface CLDSocialShareToolbar : UIToolbar <MFMailComposeViewControllerDelegate>


# pragma mark - Properties

/// The object that acts as the data source of the receiving social share toolbar
@property (nonatomic, assign) IBOutlet id<CLDSocialShareToolbarDataSource> dataSource;

/// The title label
@property (nonatomic, strong) UILabel *label_title;

/// Whether or not the background is transparent
@property (nonatomic, assign) BOOL backgroundTransparent;


@end
