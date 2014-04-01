//
//  CSHomeCollectionViewDelegate.h
//  EasyReader
//
//  Created by Joseph Lorich on 4/1/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EZRHomeViewController;

@interface EZRHomeCollectionViewDelegate : NSObject <UICollectionViewDelegate>

- (id)initWithController:(EZRHomeViewController *)homeController;

@end
