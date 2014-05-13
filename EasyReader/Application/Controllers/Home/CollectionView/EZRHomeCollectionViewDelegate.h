//
//  CSHomeCollectionViewDelegate.h
//  EasyReader
//
//  Created by Joseph Lorich on 4/1/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EZRFeedItemCollectionViewCell.h"

@class EZRHomeViewController;

/**
 * A delegate for the collection view on the home view controller
 */
@interface EZRHomeCollectionViewDelegate : NSObject <UICollectionViewDelegate, EZRFeedItemCollectionViewCellDelegate>

@end
