//
//  CSEnhancedTableView.h
//  EasyReader
//
//  Created by Joseph Lorich on 4/10/13.
//  Copyright (c) 2013 Cloudspace. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CSEnhancedTableViewStyle, CSEnhancedTableViewCell, CSEnhancedTableViewHeaderFooterView;

/**
 * An easily styled table view class
 */
@interface CSEnhancedTableView : UITableView
{
  BOOL _hasStyledTable;
  CSEnhancedTableViewStyle *_tableViewStyle;
}


#pragma mark - Properties
@property (nonatomic) CSEnhancedTableViewStyle *tableViewStyle;

#pragma mark - methods
///**
// * Dequeues a reusable styled table view
// */
//- (id) dequeueReusableStyledCellWithIdentifier:(NSString *)identifier;
//
///**
// * Dequeues a reusable header/footer view
// */
//- (id) dequeueReusableStyledHeaderFooterViewWithIdentifier:(NSString *)identifier;

@end
