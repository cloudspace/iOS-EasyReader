//
//  EZRCurrentUserProxy.m
//  EasyReader
//
//  Created by Joseph Lorich on 4/10/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import "EZRCurrentUserProxy.h"
#import "User.h"

@implementation EZRCurrentUserProxy

- (void)awakeFromNib
{
    [super awakeFromNib];
    _user = [User current];
    NSLog(@"loading");
}


@end
