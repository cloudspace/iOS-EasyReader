//
//  CSMenuSearchFeedDataSource.m
//  EasyReader
//
//  Created by Michael Beattie on 3/20/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import "EZRMenuSearchFeedDataSource.h"
#import "NSSet+CSSortingAdditions.h"
#import "UIColor+EZRSharedColorAdditions.h"

#import "EZRSearchFeedCell.h"

@implementation EZRMenuSearchFeedDataSource

- (instancetype) init{
    self = [super init];
    
    if (self) {
        self.configureCell = ^(UITableViewCell *cell, id item) {
            ((EZRSearchFeedCell *)cell).feedData = item;
        };
        
        self.reusableCellIdentifier = @"SearchFeedCell";
    }
    
    return self;
}

#pragma mark - Public methods

- (void)setFeedData:(NSDictionary *)feedData
{
    NSSet *feedSet = [NSSet setWithArray:feedData[@"feeds"]];
    
    self.source = [feedSet sortedArrayByAttributes:@"name", nil];
}


@end
