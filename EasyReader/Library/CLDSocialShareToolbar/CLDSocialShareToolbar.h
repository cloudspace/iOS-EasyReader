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



/// Signifies sharing request service types
typedef NS_ENUM(NSInteger, CLDSocialServiceType) {
    
    /// Signifies an http GET API request
    CLDServiceTypeFacebook,
    
    /// Signifies an http POST request
    CLDServiceTypeTwitter,
    
    /// Signifies an http PUT request
    CLDServiceTypeMail
};


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
 * @param serviceType The service type requested for the share.
 */
- (NSString *)socialToolbar:(CLDSocialShareToolbar *)toolbar textForShareDialogFromService:(CLDSocialServiceType)serviceType;

/**
 * Returns a url to share with the given service
 *
 * @param toolbar The social share toolbar making the request
 * @param serviceType The service type requested for the share.
 */
- (NSURL *)socialToolbar:(CLDSocialShareToolbar *)toolbar urlForShareDialogFromService:(CLDSocialServiceType)serviceType;

/**
 * Returns an image to share with the given service
 *
 * @param toolbar The social share toolbar making the request
 * @param serviceType The service type requested for the share.
 */
- (UIImage *)socialToolbar:(CLDSocialShareToolbar *)toolbar imageForShareDialogFromService:(CLDSocialServiceType)serviceType;

@end


/**
 * This protocol represents the delegate for the Social Share Toolbar control
 */
@protocol CLDSocialShareToolbarDelegate <NSObject, UIToolbarDelegate>

/**
 * Notifies the delegate that a share action was completed
 *
 * @param toolbar The social share toolbar used to make the request
 * @param serviceType The service type requested for the share.
 * @param success Whether or not the service was successful
 */
- (void)socialToolbar:(CLDSocialShareToolbar *)toolbar didCompleteShareWithService:(CLDSocialServiceType)serviceType success:(BOOL)success;

@end


#pragma mark - CLDSocialShareToolbar

/**
 * A social sharing UIToolbar implementation
 */
@interface CLDSocialShareToolbar : UIToolbar <MFMailComposeViewControllerDelegate>


# pragma mark - Properties

/// The object that acts as the data source of the receiving social share toolbar
@property (nonatomic, assign) IBOutlet id<CLDSocialShareToolbarDataSource> dataSource;

/// The object that acts as the delegate of the receiving social share toolbar
@property (nonatomic, assign) IBOutlet id<CLDSocialShareToolbarDelegate> delegate;

/// The title label
@property (nonatomic, strong) UILabel *label_title;

/// Whether or not the background is transparent
@property (nonatomic, assign) BOOL backgroundTransparent;


@end
