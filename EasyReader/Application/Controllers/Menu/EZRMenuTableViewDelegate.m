//
//  CSMenuTableViewDelegate.m
//  EasyReader
//
//  Created by Joseph Lorich on 4/7/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import "EZRMenuTableViewDelegate.h"

@implementation EZRMenuTableViewDelegate

/**
 * Handles selection of a row
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
   // NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    
//    EZRCustom
  //  defaultCenter postNotificationName:@"kEZRFeedSelected" object:<#(id)#>
}

/**
 * Height of all the cells
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}



@end
