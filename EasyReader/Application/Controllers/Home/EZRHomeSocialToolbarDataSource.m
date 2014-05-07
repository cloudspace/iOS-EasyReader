//
//  EZRHomeSocialToolbarDataSource.m
//  EasyReader
//
//  Created by Joseph Lorich on 4/18/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import "EZRHomeSocialToolbarDataSource.h"
#import "EZRHomeViewController.h"
#import "FeedItem.h"
#import "EZRGoogleAnalyticsService.h"
#import "CLDSocialShareToolbar.h"

@interface EZRHomeSocialToolbarDataSource ()

///
@property (nonatomic, weak) IBOutlet EZRHomeViewController *controller;

@end


@implementation EZRHomeSocialToolbarDataSource


- (UIViewController *)containingViewControllerForDialogFromSocialToolbar:(CLDSocialShareToolbar *)toolbar
{
    return self.controller;
}

- (NSString *)socialToolbar:(CLDSocialShareToolbar *)toolbar textForShareDialogFromService:(NSString *)serviceType {
    return self.controller.currentFeedItem.title;
}

- (NSURL *)socialToolbar:(CLDSocialShareToolbar *)toolbar urlForShareDialogFromService:(NSString *)serviceType {
    return [NSURL URLWithString:self.controller.currentFeedItem.url];
}

//- (UIImage *)socialToolbar:(CSSocialShareToolbar *)toolbar imageForShareDialogFromService:(NSString *)serviceType {
//    
//}

@end
