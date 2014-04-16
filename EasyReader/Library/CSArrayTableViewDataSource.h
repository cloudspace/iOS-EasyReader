//
//  CSArrayTableViewDataSource.h
//  EasyReader
//
//  Created by Joseph Lorich on 4/14/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * A generic array data source
 */
@interface CSArrayTableViewDataSource : NSObject <UITableViewDataSource>


/// The array soruce
@property (nonatomic, retain) NSArray *source;

/// The reusable cell identifier to load
@property (nonatomic, retain) NSString *reusableCellIdentifier;

/// A block to configure the cell
@property (nonatomic, copy) void (^configureCell)(UITableViewCell *cell, id item);

/// A block to handle deleting an item
@property (nonatomic, copy) void (^deleteItem)(id item);


@end
