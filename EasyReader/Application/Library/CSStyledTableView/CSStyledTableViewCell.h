//
//  CSStyledTableViewCell.h
//  EasyReader
//
//  Created by Joseph Lorich on 4/10/13.
//  Copyright (c) 2013 Cloudspace. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CSStyledTableViewStyle;


@interface CSStyledTableViewCell : UITableViewCell


#pragma mark - IBOutlet Properties
@property (nonatomic) CSStyledTableViewStyle *tableViewStyle; ///< The style for this cell


#pragma mark - Methods
/**
 * Inits a cell with a given table view style and reuse identifier
 */
- (id)initWithTableViewStyle:(CSStyledTableViewStyle *)tableViewStyle reuseIdentifier:(NSString *)reuseIdentifier;

@end
