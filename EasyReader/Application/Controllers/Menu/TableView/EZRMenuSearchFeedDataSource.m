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
{
    NSString *_lastSearchTerm;
}

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

- (void) setLastSearchTerm:(NSString *)lastSearchTerm {
    _lastSearchTerm = lastSearchTerm;
}

- (void)setFeedData:(NSDictionary *)feedData
{
    if (feedData) {
        NSSet *feedSet = [NSSet setWithArray:feedData[@"feeds"]];
        
        self.source = [feedSet sortedArrayByAttributes:@[@"name"] ascending:YES];
    } else {
        self.source = nil;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger numberOfResults = [super tableView:tableView numberOfRowsInSection:section];
    
    if (numberOfResults == 0 && self.source.count == 0) {
        return 1;
    }
    
    return numberOfResults;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    
    if (indexPath.section == 0 && indexPath.row == 0 && self.source.count == 0 && _lastSearchTerm.length > 0) {
        cell =  [tableView dequeueReusableCellWithIdentifier:@"NoResultsFoundCell"];
    } else if (indexPath.section == 0 && indexPath.row == 0 && self.source.count == 0 && _lastSearchTerm.length == 0) {
        cell =  [tableView dequeueReusableCellWithIdentifier:@"NoSearchTextCell"];
    } else {
        cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}


@end
