//
//  CSArrayCollectionViewDataSource.h
//  EasyReader
//
//  Created by Joseph Lorich on 4/15/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * A data source object based around a source array
 */
@interface CSArrayCollectionViewDataSource : NSObject <UICollectionViewDataSource>


/// The array soruce
@property (nonatomic, retain) NSArray *source;

/// The reusable cell identifier to load
@property (nonatomic, retain) NSString *reusableCellIdentifier;

/// A block to configure the cell
@property (nonatomic, copy) void (^configureCell)(UICollectionViewCell *cell, id item);




+ (CSArrayCollectionViewDataSource *)dataSourceWithArray:(NSArray *)array
                                 reusableCellIdentifier:(NSString*)reusableCellIdentifier
                                         configureBlock:(void (^)(UICollectionViewCell *cell, id item))configureBlock;
@end
