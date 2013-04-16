//
//  CSFeedCreateViewController.h
//  EasyReader
//
//  Created by Joseph Lorich on 4/9/13.
//  Copyright (c) 2013 Cloudspace. All rights reserved.
//

#import "CSBaseViewController.h"

@class Feed;

@interface CSFeedCreateViewController : CSBaseViewController

#pragma mark - Properties
@property (nonatomic, retain) UIBarButtonItem *barButton_save;
@property (nonatomic, retain) UIBarButtonItem *barButton_cancel;
@property (nonatomic, retain) Feed *feed;


#pragma mark - IBOutlet Properties
@property (nonatomic, retain) IBOutlet UITextField *textField_name;
@property (nonatomic, retain) IBOutlet UITextField *textField_url;
@property (nonatomic, retain) IBOutlet UITabBar    *tabBar_select;


@end
