//
//  EZRFeedImageServiceTests.m
//  EasyReader
//
//  Created by Alfredo Uribe on 4/18/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "EZRBaseServiceTests.h"
#import "EZRFeedImageService.h"
#import "SDImageCache.h"
#import "SDWebImageDownloader.h"

@interface EZRFeedImageService (Test)

- (void)addCompletionBlocksForURLString:(NSString *)urlString
                                success:(void (^)(UIImage *image, UIImage *blurredImage))success
                                failure:(void (^)())failure;

- (BOOL)isImageCurrentlyBeingProcessedForURLString:(NSString *)urlString;

- (void)markImageForURLString:(NSString *)urlString asBeingProcessed:(BOOL)processing;

- (void)triggerCompletionBlocksForUrlString:(NSString *)urlString
                                  withImage:(UIImage*)image
                               blurredImage:(UIImage *)blurredImage;

- (void)downloadAndProcessImageAtURLString:(NSString *)urlString;

- (void)blurredBlockForURLString:(NSString *)urlString withImage:(UIImage *)image;

- (void)triggerOrDownloadForURLString:(NSString *)urlString
                            withImage:(UIImage *)image
                         blurredImage:(UIImage *)blurredImage;

- (void)downloadImageAtURLString:(NSString *)urlString
                         success:(void (^)(UIImage *image))success
                         failure:(void (^)())failure;

- (void)downloadAndProcessImage:(UIImage *)image atURLString:(NSString *)urlString;

- (UIImage *)processImage:(UIImage *)image;

- (UIImage *)cropImage:(UIImage *)image toRect:(CGRect)rect  uiScale:(CGFloat)scale;
- (UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)size uiScale:(CGFloat)scale;
- (UIImage *)enhanceImage:(UIImage *)image
               saturation:(CGFloat)saturation
                 contrast:(CGFloat)contrast
               brightness:(CGFloat)brightness;
- (UIImage *)flipImage:(UIImage *)image;
- (UIImage *)blurImage:(UIImage*)image;

@end

@interface EZRFeedImageServiceTests : EZRBaseServiceTests
{
    EZRFeedImageService *testService;
    id mockService;
    id partialMockService;
    
    id mockImageCache;
    id mockBlurredCache;
    
    id mockImage;
    id mockBlurredImage;
}
@end

@implementation EZRFeedImageServiceTests

- (void)setUp
{
    [super setUp];
    testService = [[EZRFeedImageService alloc] init];
    mockService = [OCMockObject mockForClass:[EZRFeedImageService class]];
    partialMockService = [OCMockObject partialMockForObject:[[EZRFeedImageService alloc] init]];
    
    mockImageCache = [OCMockObject mockForClass:[SDImageCache class]];
    mockBlurredCache = [OCMockObject mockForClass:[SDImageCache class]];
    
    mockImage = [OCMockObject mockForClass:[UIImage class]];
    mockBlurredImage = [OCMockObject mockForClass:[UIImage class]];
}

- (void)tearDown
{
    testService = nil;
    mockService = nil;
    partialMockService = nil;
    
    mockImageCache = nil;
    mockBlurredCache = nil;
    
    mockImage = nil;
    mockBlurredImage = nil;
    
    [super tearDown];
}

- (void)testSharedWithNoSharedInstanceSet
{
    XCTAssertTrue([[EZRFeedImageService shared] isKindOfClass:[EZRFeedImageService class]], @"");
}

- (void)testSharedWithSetSharedInstance
{
    testService = [EZRFeedImageService shared];
    XCTAssertTrue([EZRFeedImageService shared] == testService, @"");
}

- (void)testSetShared
{
    [EZRFeedImageService setShared:testService];
    XCTAssertTrue([EZRFeedImageService shared] == testService, @"");
}

- (void)testFetchImageAtURLString
{
    [[partialMockService expect] fetchImageAtURLString:@"test"
                                        success:nil
                                        failure:nil];
    
    [partialMockService fetchImageAtURLString:@"test"];
    [partialMockService verify];
}

- (void)testFetchImageAtURLStringSuccessFailureBeingProcessed
{
    [[partialMockService expect] addCompletionBlocksForURLString:@"test"
                                                         success:nil
                                                         failure:nil];
    
    [[[partialMockService stub] andReturnValue:@YES] isImageCurrentlyBeingProcessedForURLString:@"test"];

    [partialMockService fetchImageAtURLString:@"test"
                                      success:nil
                                      failure:nil];
    
    [partialMockService verify];
}

//// need imageCache and blurredImageCache to be a properties for full test
- (void)testFetchImageAtURLStringSuccessFailureNotBeingProcessed
{
    [[partialMockService expect] addCompletionBlocksForURLString:@"test"
                                                         success:nil
                                                         failure:nil];
    [[[partialMockService stub] andReturnValue:@NO] isImageCurrentlyBeingProcessedForURLString:@"test"];
    [[partialMockService expect] markImageForURLString:@"test" asBeingProcessed:YES];
    
    //[partialMockService setImageCache:mockImageCache];
    //[[mockImageCache expect] queryDiskCacheForKey:@"test" done:[OCMArg any]];

    [partialMockService fetchImageAtURLString:@"test"
                                      success:nil
                                      failure:nil];
    
    [partialMockService verify];
}

//- (void)testBlurredBlockForURLString
//{
//    [[mockBlurredCache expect] queryDiskCacheForKey:@"test" done:[OCMArg any]];
//    
//    [partialMockService blurredBlockForURLString:@"test"
//                                       withImage:mockImage];
//    
//    [partialMockService verify];
//}

- (void)testTriggerOrDownloadForURLStringWithImageAndBlurredImage
{
    [[partialMockService expect] triggerCompletionBlocksForUrlString:@"test"
                                                           withImage:[OCMArg any]
                                                        blurredImage:[OCMArg any]];
    [[partialMockService expect] markImageForURLString:@"test" asBeingProcessed:NO];
    
    [partialMockService triggerOrDownloadForURLString:@"test"
                                            withImage:mockImage
                                         blurredImage:mockBlurredImage];
    
    [partialMockService verify];
}

- (void)testTriggerOrDownloadForURLStringWithOnlyImage
{
    [[partialMockService expect] downloadAndProcessImageAtURLString:@"test"];
    
    [partialMockService triggerOrDownloadForURLString:@"test"
                                            withImage:mockImage
                                         blurredImage:nil];
    
    [partialMockService verify];
}

- (void)testDownloadAndProcessImageAtURLString
{
    [[partialMockService expect] downloadImageAtURLString:@"test"
                                                  success:[OCMArg any]
                                                  failure:[OCMArg any]];
    
    [partialMockService triggerOrDownloadForURLString:@"test"
                                            withImage:mockImage
                                         blurredImage:nil];
    [partialMockService verify];
}

///////////////// would need imageCache and blurredImageCache to be a properties
//- (void)testDownloadAndProcessImage
//{
//    [[[partialMockService expect] andReturn:mockBlurredImage ] processImage:mockImage];
//    
//    [[partialMockService expect] markImageForURLString:@"test" asBeingProcessed:NO];
//    [[partialMockService expect] triggerCompletionBlocksForUrlString:@"test"
//                                                           withImage:mockImage
//                                                        blurredImage:mockBlurredImage];
//    [partialMockService setImageCache:mockImageCache];
//    [[mockImageCache expect] storeImage:mockImage forKey:@"test"];
//    
//    [partialMockService setBlurredImageCache:mockBlurredCache];
//    [[mockBlurredCache expect] storeImage:mockImage forKey:@"test"];
//    
//    [partialMockService downloadAndProcessImage:mockImage atURLString:@"test"];
//    [partialMockService verify];
//}

///////////////// would need imageURLsCurrentlyBeingProcessed to be a property
//- (void)testMarkImageForURLStringAsBeingProcessedYes
//{
//    [partialMockService markImageForURLString:@"test" asBeingProcessed:YES];
//    [partialMockService verify];
//}
//
//- (void)testMarkImageForURLStringAsBeingProcessedNo
//{
//    [partialMockService markImageForURLString:@"test" asBeingProcessed:NO];
//    [partialMockService verify];
//}

- (void)testProcessImage
{
    [[[partialMockService expect] andReturn:mockImage] scaleImage:mockImage toSize:CGSizeMake(340, 420) uiScale:1.0f];
    [[[partialMockService expect] andReturn:mockImage] blurImage:mockImage];
    [[[partialMockService expect] andReturn:mockImage] cropImage:mockImage toRect:CGRectMake(10, 160, 320, 200) uiScale:1.0f];
    [[[partialMockService expect] andReturn:mockImage] enhanceImage:mockImage saturation:2.5 contrast:1.5 brightness:0.75];
    [[[partialMockService expect] andReturn:mockImage] flipImage:mockImage];
    
    [partialMockService processImage:mockImage];
    [partialMockService verify];
}

@end
