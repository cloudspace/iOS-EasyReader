//
//  CSFeedCreateViewController.h
//  EasyReader
//
//  Created by Joseph Lorich on 4/9/13.
//  Copyright (c) 2013 Cloudspace. All rights reserved.
//

#import "CSBaseViewController.h"
#import "CSAutoCompleteViewController.h"

@class Feed, AFJSONRequestOperation;


@interface CSFeedAddViewController : CSBaseViewController <CSAutoCompleteDelegate, UIActionSheetDelegate>

#pragma mark - Properties
@property (nonatomic, retain) UIBarButtonItem *barButton_save;
@property (nonatomic, retain) UIBarButtonItem *barButton_cancel;
@property (nonatomic, retain) Feed *feed;


@property (nonatomic, retain) UIView *view_addCustomFeed;
@property (nonatomic, retain) UITextField *textFieldName;
@property (nonatomic, retain) UITextField *textFieldURL;


@property (nonatomic, retain) CSAutoCompleteViewController *autoCompleteController;
@property (nonatomic, retain) AFJSONRequestOperation *requestOperation;
@property (nonatomic, retain) NSArray *availableFeeds;
@property (nonatomic, retain) NSArray *defaultData;



@end
