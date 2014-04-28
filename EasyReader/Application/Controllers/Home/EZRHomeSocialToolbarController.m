//
//  EZRHomeSocialToolbarDataSource.m
//  EasyReader
//
//  Created by Joseph Lorich on 4/18/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import "EZRHomeSocialToolbarController.h"
#import "EZRHomeViewController.h"
#import "FeedItem.h"
#import "TSMessage.h"

@interface EZRHomeSocialToolbarController ()

///
@property (nonatomic, weak) IBOutlet EZRHomeViewController *controller;

@end


@implementation EZRHomeSocialToolbarController


- (UIViewController *)containingViewControllerForDialogFromSocialToolbar:(CLDSocialShareToolbar *)toolbar
{
    return self.controller;
}

- (NSString *)socialToolbar:(CLDSocialShareToolbar *)toolbar textForShareDialogFromService:(CLDSocialServiceType)serviceType {
    return self.controller.currentFeedItem.title;
}

- (NSURL *)socialToolbar:(CLDSocialShareToolbar *)toolbar urlForShareDialogFromService:(CLDSocialServiceType)serviceType {
    return [NSURL URLWithString:self.controller.currentFeedItem.url];
}

- (void)socialToolbar:(CLDSocialShareToolbar *)toolbar didCompleteShareWithService:(CLDSocialServiceType)serviceType success:(BOOL)success {
    if (success) {
        [TSMessage showNotificationInViewController:self.controller title:@"Easy Reader" subtitle:@"This page has been successfully shared." type:TSMessageNotificationTypeSuccess];
    }
}


@end
