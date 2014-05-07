//
//  EZRFeedImageAdditions.m
//  EasyReader
//
//  Created by Alfredo Uribe on 4/17/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "EZRBaseCategoryTests.h"
#import "UIImageView+EZRFeedImageAdditions.h"
#import "EZRFeedImageService.h"

@interface EZRFeedImageAdditions : EZRBaseCategoryTests
{
    id mockImageService;
    UIImageView *imageView;
}
@end

@implementation EZRFeedImageAdditions

- (void)setUp
{
    [super setUp];
    imageView = [[UIImageView alloc] init];
    mockImageService = [OCMockObject mockForClass:[EZRFeedImageService class]];
    [EZRFeedImageService setShared:mockImageService];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testSetImageForURLString
{
    [[mockImageService expect] fetchImageAtURLString:@"test"
                                             success:[OCMArg any]
                                             failure:[OCMArg any]];
    
    [imageView setImageForURLString:@"test"];
    [mockImageService verify];
}

- (void)testSetBlurredImageForURLString
{
    [[mockImageService expect] fetchImageAtURLString:@"test"
                                             success:[OCMArg any]
                                             failure:[OCMArg any]];
    
    [imageView setBlurredImageForURLString:@"test"];
    [mockImageService verify];
}

@end
