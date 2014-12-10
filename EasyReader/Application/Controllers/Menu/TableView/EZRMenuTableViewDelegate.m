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
#import "EZRCurrentFeedsProvider.h"

#import "Feed.h"
#import "User.h"

#import "SVProgressHUD.h"
#import "TSMessage.h"
#import "EZRGoogleAnalyticsService.h"

@interface EZRMenuTableViewDelegate ()

/// The menu search controller
@property (nonatomic, weak) IBOutlet EZRMenuSearchController *searchController;

@end


@implementation EZRMenuTableViewDelegate

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

    if ([cell isKindOfClass:[EZRMenuFeedCell class]]) {
        EZRMenuFeedCell  *ezrcell = (EZRMenuFeedCell *)cell;
        if (!ezrcell.feed) {
            return UITableViewCellEditingStyleNone;
        }
    } else if ([cell isKindOfClass:[EZRSearchFeedCell class]]) {
        return UITableViewCellEditingStyleNone;
    }
    
    return UITableViewCellEditingStyleDelete;
}


/**
 * Handles selection of a row
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if ([tableView.dataSource isKindOfClass:[EZRMenuSearchFeedDataSource class]]) {
        NSDictionary *feedData = ((EZRSearchFeedCell *)cell).feedData;
        
        Feed *existingFeed = [Feed MR_findFirstByAttribute:@"id" withValue:feedData[@"id"]];
        [self.searchController cancelSearch];
        
        if (!existingFeed) {
            UIViewController *rootVC = [[[UIApplication sharedApplication].delegate window] rootViewController];
            
            [Feed createFeedWithUrl:feedData[@"url"]
                            success:^(id responseObject, NSInteger httpStatus) {
                                [[EZRGoogleAnalyticsService shared] sendView:@"Feed Added"];
                                [TSMessage showNotificationInViewController:rootVC
                                                                      title:@"Easy Reader"
                                                                   subtitle:@"The selected feed has been added to the menu.  Please allow a few minutes for new items to populate."
                                                                       type:TSMessageNotificationTypeSuccess];
                            }
                            failure:^(id responseObject, NSInteger httpStatus, NSError *error) {
                                [TSMessage showNotificationInViewController:rootVC
                                                                      title:@"Easy Reader"
                                                                   subtitle:@"There was an error adding that feed.  Please try again later."
                                                                       type:TSMessageNotificationTypeError];
            }];
        }
        else if (![[User current].feeds containsObject:existingFeed])
        {
            [[User current] addFeedsObject:existingFeed];
        }
        
        [tableView reloadData];
        
    } else {
        Feed *feed = ((EZRMenuFeedCell *)cell).feed;
        [self postSelectedNotificationForFeed:feed];
        [((MFSideMenuContainerViewController *)tableView.window.rootViewController) setMenuState:MFSideMenuStateClosed];
    }
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
