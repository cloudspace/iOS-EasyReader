//
//  CSMenuTableViewDelegate.m
//  EasyReader
//
//  Created by Joseph Lorich on 4/7/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import "EZRMenuTableViewDelegate.h"
#import "EZRMenuUserFeedDataSource.h"
#import "EZRMenuSearchFeedDataSource.h"
#import "EZRSearchFeedCell.h"
#import "EZRMenuFeedCell.h"

#import "EZRMenuSearchController.h"
#import "EZRRootViewController.h"

#import "Feed.h"
#import "User.h"

#import "SVProgressHUD.h"

#import "TSMessage.h"

@interface EZRMenuTableViewDelegate ()

/// The menu search controller
@property (nonatomic, weak) IBOutlet EZRMenuSearchController *searchController;

@end


@implementation EZRMenuTableViewDelegate

/**
 * Handles selection of a row
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([tableView.dataSource isKindOfClass:[EZRMenuSearchFeedDataSource class]]) {
        NSDictionary *feedData = ((EZRSearchFeedCell *)[tableView cellForRowAtIndexPath:indexPath]).feedData;
        
        Feed *existingFeed = [Feed MR_findFirstByAttribute:@"id" withValue:feedData[@"id"]];
        
        if (!existingFeed) {
            UIViewController *rootVC = [[[UIApplication sharedApplication].delegate window] rootViewController];
            
            [Feed createFeedWithUrl:feedData[@"url"] success:^(id responseObject, NSInteger httpStatus) {
                [TSMessage showNotificationInViewController:rootVC title:@"Easy Reader" subtitle:@"The selected feed has been added to the menu.  Please allow a few minutes for new items to populate." type:TSMessageNotificationTypeSuccess];
            } failure:^(id responseObject, NSInteger httpStatus, NSError *error) {
                [TSMessage showNotificationInViewController:rootVC title:@"Easy Reader" subtitle:@"There was an error adding that feed.  Please try again later." type:TSMessageNotificationTypeError];
            }];
        }
        else if (![[User current].feeds containsObject:existingFeed])
        {
            [[User current] addFeedsObject:existingFeed];
            [self postSelectedNotificationForFeed:existingFeed];
        }
        
        [self.searchController cancelSearch];
        [tableView reloadData];
        
    } else {
        Feed *feed = ((EZRMenuFeedCell *)[tableView cellForRowAtIndexPath:indexPath]).feed;
        [self postSelectedNotificationForFeed:feed];
    }
    
    [((MFSideMenuContainerViewController *)tableView.window.rootViewController) setMenuState:MFSideMenuStateClosed];
}

/**
 * Sends out a kEZRFeedSelected notification
 *
 * @param feed The feed to notify the selection of
 */
- (void)postSelectedNotificationForFeed:(Feed *)feed
{
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter postNotificationName:@"kEZRFeedSelected" object:feed];
}

/**
 * Height of all the cells
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}



@end
