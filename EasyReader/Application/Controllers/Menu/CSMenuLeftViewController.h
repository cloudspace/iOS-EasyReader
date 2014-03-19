//
//  CSMenuLeftViewController.h
//  EasyReader
//
//  Created by Joseph Lorich on 4/4/13.
//  Copyright (c) 2013 Cloudspace. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSBaseViewController.h"

@class Feed, User, CSEnhancedTableView;

@interface CSMenuLeftViewController : CSBaseViewController


#pragma mark - IBOutlet Properties
@property (nonatomic, retain) IBOutlet CSEnhancedTableView *tableView_feeds;
@property (strong, nonatomic) IBOutlet UITextField *textField_searchInput;


#pragma mark - Properties
@property (nonatomic, retain) NSMutableSet *feeds;
@property (nonatomic, retain) User *currentUser;


@end
