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

@interface EZRHomeSocialToolbarDataSource ()

///
@property (nonatomic, weak) IBOutlet EZRHomeViewController *controller;

@end


@implementation EZRHomeSocialToolbarDataSource


- (UIViewController *)containingViewControllerForDialogFromSocialToolbar:(CSSocialShareToolbar *)toolbar
{
    return self.controller;
}

- (NSString *)socialToolbar:(CSSocialShareToolbar *)toolbar textForShareDialogFromService:(NSString *)serviceType {
    return self.controller.currentFeedItem.title;
}

- (NSURL *)socialToolbar:(CSSocialShareToolbar *)toolbar urlForShareDialogFromService:(NSString *)serviceType {
    return [NSURL URLWithString:self.controller.currentFeedItem.url];
}

//- (UIImage *)socialToolbar:(CSSocialShareToolbar *)toolbar imageForShareDialogFromService:(NSString *)serviceType {
//    
//}

@end
