//
//  EZRCustomFeedCell.m
//  EasyReader
//
//  Created by Michael Beattie on 3/24/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import "EZRCustomFeedCell.h"
#import "Feed.h"
#import "User.h"

@implementation EZRCustomFeedCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

/**
 * Sets the fields in the cell
 *
 * @param feedData The NSDicitionary of the custom feed
 */
- (void)setFeedData:(NSDictionary *)feedData
{
    _feedData = feedData;
    
    NSString *customUrl = [feedData objectForKey:@"url"];
    self.label_url.text = customUrl;
    
    // Hide the add button unless the user types a valid url
    [self.button_addCustomFeed setHidden:YES];
    if([self isValidUrl:customUrl]){
        [self.button_addCustomFeed setHidden:NO];
    }

}

/**
 * Check for a letter followed by a dot
 *
 * @param url The custom feed url
 */
- (BOOL)isValidUrl:(NSString *)url
{
    NSError *error = NULL;
    NSString *pattern = @"[a-z][.]";
    NSString *string = url;
    NSRange range = NSMakeRange(0, string.length);
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray *matches = [regex matchesInString:string options:NSMatchingReportCompletion range:range];
    
    if (matches.count > 0) {
        return YES;
    }
    return NO;
}
@end
