//
//  CSMenuLeftViewController.h
//  EasyReader
//
//  Created by Joseph Lorich on 4/4/13.
//  Copyright (c) 2013 Cloudspace. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSBaseViewController.h"

@class Feed, User, CSStyledTableView;

@interface CSMenuLeftViewController : CSBaseViewController <
  UITableViewDataSource,
  UITableViewDelegate
>


#pragma mark - IBOutlet Properties
@property (nonatomic, retain) IBOutlet CSStyledTableView *tableView_feeds;


#pragma mark - Properties
@property (nonatomic, retain) NSArray *feeds;
@property (nonatomic, retain) User *currentUser;


@end
