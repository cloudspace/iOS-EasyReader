//
//  CSHomeFeedObserver.h
//  EasyReader
//
//  Created by Joseph Lorich on 4/1/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EZRHomeViewController;
@class EZRHomeCollectionViewDataSource;


@interface EZRHomeFeedObserver : NSObject

- (id)initWithController:(EZRHomeViewController *)homeController
               feedItems:(NSMutableSet *)feedItems
collectionViewDataSource:(EZRHomeCollectionViewDataSource *)collectionViewDataSource
             currentUser:(User *)currentUser;

- (void (^)(EZRHomeViewController *, NSSet *, NSSet *)) feedsDidChange;

@end
