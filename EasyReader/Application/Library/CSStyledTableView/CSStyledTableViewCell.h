//
//  CSStyledTableViewCell.h
//  EasyReader
//
//  Created by Joseph Lorich on 4/10/13.
//  Copyright (c) 2013 Cloudspace. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
@class CSStyledTableViewStyle;


@interface CSStyledTableViewCell : UITableViewCell


#pragma mark - IBOutlet Properties
@property (nonatomic) CSStyledTableViewStyle *tableViewStyle; ///< The style for this cell


#pragma mark - Properties
@property (nonatomic, retain) CAGradientLayer *gradientBackgroundLayer;



#pragma mark - Methods
/**
 * Inits a cell with a given table view style and reuse identifier
 */
- (id)initWithTableViewStyle:(CSStyledTableViewStyle *)tableViewStyle reuseIdentifier:(NSString *)reuseIdentifier;

@end
