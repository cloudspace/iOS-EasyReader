//
//  CSEnhancedTableViewHeaderFooterView.h
//  EasyReader
//
//  Created by Joseph Lorich on 4/10/13.
//  Copyright (c) 2013 Cloudspace. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


@class CSEnhancedTableViewStyle;


@interface CSEnhancedTableViewHeaderFooterView : UITableViewHeaderFooterView


#pragma mark - IBOutlet Properties
@property (nonatomic, retain) CSEnhancedTableViewStyle *tableViewStyle;
@property (nonatomic, retain) UIView *overrideBackgroundView;

@property (nonatomic, retain) UIView *lineViewTop1;
@property (nonatomic, retain) UIView *lineViewTop2;
@property (nonatomic, retain) UIView *lineViewBottom1;
@property (nonatomic, retain) UIView *lineViewBottom2;

@property (nonatomic, retain) CAGradientLayer *gradientBackgroundLayer;


@property (nonatomic, retain) UILabel *titleLabel;


#pragma mark - Methods
/**
 * Inits a header with a given table view style and reuse identifier
 */
- (id) initWithTableViewStyle:(CSEnhancedTableViewStyle *)style ReuseIdentifier:(NSString *)reuseIdentifier;


@end
