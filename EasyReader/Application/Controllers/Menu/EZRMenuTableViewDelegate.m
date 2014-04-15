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
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    
    if ([tableView.dataSource isKindOfClass:[EZRMenuSearchFeedDataSource class]]) {
        NSDictionary *feedData = ((EZRSearchFeedCell *)[tableView cellForRowAtIndexPath:indexPath]).feedData;
        
        Feed *existingFeed = [Feed MR_findFirstByAttribute:@"id" withValue:feedData[@"id"]];
        
        if (!existingFeed) {
        
            [Feed createFeedWithUrl:feedData[@"url"] success:^(id responseObject, NSInteger httpStatus) {
                
            } failure:^(id responseObject, NSInteger httpStatus, NSError *error) {
                
            }];
        }
        
        [self.searchController cancelSearch];
        [tableView reloadData];
        
    } else {
        Feed *feed = ((EZRMenuFeedCell *)[tableView cellForRowAtIndexPath:indexPath]).feed;
        [defaultCenter postNotificationName:@"kEZRFeedSelected" object:feed];
    }
    
    [((MFSideMenuContainerViewController *)tableView.window.rootViewController) setMenuState:MFSideMenuStateClosed];
}

/**
 * Height of all the cells
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}



@end
