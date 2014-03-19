//
//  CSFakedDataRequestor.m
//  EasyReader
//
//  Created by Jeremiah Hemphill on 3/10/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import "CSFakedDataRequestor.h"

@implementation CSFakedDataRequestor

- (void) requestRoute:(NSString *) routeName
                     withParams:(NSDictionary *) params
                        success:(void(^)(AFHTTPRequestOperation *operation, id responseObject)) successBlock
                        failure:(void(^)(AFHTTPRequestOperation *operation, id responseObject)) failureBlock;
{
  NSDictionary *route = [self routes][routeName];
  NSString *method = route[@"method"];
  NSString *path = route[@"path"];
  
  NSDictionary *data;
  
  if([method isEqualToString:@"GET"]) {
    if ([path rangeOfString:@"feed_items"].location != NSNotFound) {
      data = [self feedItemsResponse];
    } else if ([path rangeOfString:@"feeds"].location != NSNotFound) {
      //for now, the feed defaults and search return the same values
      data = [self feedsResponse];
    } else {
      //this path is not handled by the response faker
      data = @{};
    }
  } else {
    //post/other requests not supported right now
    data = @{};
  }

  if (successBlock) successBlock(nil, data);
}

//these feeds are used for both the search and the defaults endpoints
//their ids should match the feed_id fields on the feedItemsResponse
- (NSDictionary *) feedsResponse
{
  NSArray *items = [NSArray arrayWithObjects:@{@"id": @1,
                                                 @"name": @"Cloudspace Feed",
                                                 @"url": @"http://www.engadget.com/rss.xml",
                                                 @"icon": @"http://s3.amazonaws.com/rss.cloudspace.com/feed/1/icon.png", //note: this image does not work on 3-11-2014
                                                 @"feed_items": @[]},
                                               @{@"id": @2,
                                                 @"name": @"EasyReader Feed",
                                                 @"url": @"http://www.engadget.com/rss.xml",
                                                 @"icon": @"http://s3.amazonaws.com/rss.cloudspace.com/feed/2/icon.png", //note: this image does not work on 3-11-2014
                                                 @"feed_items": @[]}, nil];
    return @{@"feeds": items};
}

- (NSDictionary *) feedItemsResponse
{
    NSArray *items = [NSArray arrayWithObjects:@{@"id": @1,
                                                 @"feed_id": @1,
                                                 @"title": @"Facebook Paper Has Forever Changed the Way We Build Mobile Apps",
                                                 @"summary": @"Everyone’s jaws just dropped. Everyone started exchanging these glances that were like: ‘What did he just do?",
                                                 @"image": @"http://s3.amazonaws.com/rss.cloudspace.com/feed_items/255/image.png",
                                                 @"url": @"http://www.wired.com/wiredenterprise/2014/03/facebook-paper/",
                                                 @"created_at": @"2014-03-05T22:32:32+00:00",
                                                 @"updated_at": @"2014-03-05T22:32:32+00:00",
                                                 @"published_at": @"2014-03-04T19:52:13+00:00"},
                      @{@"id": @2,
                        @"feed_id": @2,
                        @"title": @"The Wolfram Technology Conference Egg-Bot Challenge Winners",
                        @"summary": @"We have a programming competition every year at the Wolfram Technology Conference, which in past years was the Mathematica One-Liner Competition. This year we held the Egg-Bot Challenge, a change of pace to give attendees a chance to exercise their graphics skills.",
                        @"image": @"https://s3.amazonaws.com/easy-reader-images/eb1.png",
                        @"url": @"http://blog.wolfram.com/2014/01/14/the-wolfram-technology-conference-egg-bot-challenge-winners/",
                        @"created_at": @"2014-03-05T22:32:33+00:00",
                        @"updated_at": @"2014-03-05T22:32:33+00:00",
                        @"published_at": @"2014-03-04T19:52:13+00:00"},
                      @{@"id": @3,
                        @"feed_id": @1,
                        @"title": @"Docker 0.9: introducing execution drivers and libcontainer",
                        @"summary": @"Today we are happy to introduce Docker 0.9. With this release we are continuing our focus on quality over features, shrinking and stabilizing the core, and providing first-class support for all major operating systems.",
                        @"image": @"https://s3.amazonaws.com/easy-reader-images/si1.png",
                        @"url": @"http://blog.docker.io/2014/03/docker-0-9-introducing-execution-drivers-and-libcontainer/",
                        @"created_at": @"2014-03-05T22:32:34+00:00",
                        @"updated_at": @"2014-03-05T22:32:34+00:00",
                        @"published_at": @"2014-03-04T19:52:14+00:00"},
                      @{@"id": @4,
                        @"feed_id": @2,
                        @"title": @"How An Arcane Coding Method From 1970s Banking Software Could Save The Sanity Of Web Developers Everywhere ",
                        @"summary": @"Forty years ago, a Canadian bank pioneered a brand new computer system that allowed non-programmers to help write code. The paradigm was so disruptive that it was ignored by computer scientists for decades. But as web apps get increasingly complex, and web devs become increasingly stressed out, “flow-based programming” may be raging back to life.",
                        @"image": @"https://s3.amazonaws.com/easy-reader-images/grid.png", //note: this image does not work on 3-11-2014
                        @"url": @"http://www.fastcolabs.com/3016289/how-an-arcane-coding-method-from-1970s-banking-software-could-save-the-sanity-of-web-develop",
                        @"created_at": @"2014-03-05T22:32:35+00:00",
                        @"updated_at": @"2014-03-05T22:32:35+00:00",
                        @"published_at": @"2014-03-04T19:52:15+00:00"},
                      @{@"id": @5,
                        @"feed_id": @1,
                        @"title": @"How Thieves Steal Your Bitcoins",
                        @"summary": @"Even though Bitcoin exchange Mt. Gox and Canadian bank Flexcoin had to shut down after recent cyber-attacks, crypto-currencies continue to grow in popularity. The soaring value of virtual crypto-currencies such as Bitcoin makes them attractive to thieves, however, and users need to take steps to secure their wallets.",
                        @"image": @"https://s3.amazonaws.com/easy-reader-images/bc1.png",
                        @"url": @"http://securitywatch.pcmag.com/malware/321388-how-thieves-steal-your-bitcoins?mailingID=7C77FA6460D99C2C4A0D92B843079466",
                        @"created_at": @"2014-03-05T22:32:36+00:00",
                        @"updated_at": @"2014-03-05T22:32:36+00:00",
                        @"published_at": @"2014-03-04T19:52:16+00:00"},
                      @{@"id": @6,
                        @"feed_id": @2,
                        @"title": @"DoSomething.org Is Upping the Snapchat Game",
                        @"summary": @"DoSomething.org is all about empowering young people. \n\n The organization, one of the largest non-profits for teens and young adults in the United States, connects 13-to-25 year olds through a wide variety of social causes. It didn’t take long for DoSomething.org strategy leaders to realize that Snapchat users fall within that exact age demographic.",
                        @"image": @"https://s3.amazonaws.com/easy-reader-images/yt1.png",
                        @"url": @"http://mashable.com/2014/03/09/dosomething-snapchat/#:eyJzIjoidCIsImkiOiJfMDhiOWhsYmI1NzViNXB0bCJ9",
                        @"created_at": @"2014-03-05T22:32:37+00:00",
                        @"updated_at": @"2014-03-05T22:32:37+00:00",
                        @"published_at": @"2014-03-04T19:52:17+00:00"},
                      @{@"id": @7,
                        @"feed_id": @1,
                        @"title": @"The Youngest Technorati",
                        @"summary": @"Ryan Orbuch, 16 years old, rolled a suitcase to the front door of his family’s house in Boulder, Colo., on a Friday morning a year ago. He was headed for the bus stop, then the airport, then Texas.",
                        @"image": @"http://s3.amazonaws.com/rss.cloudspace.com/feed_items/255/image.png",
                        @"url": @"http://www.nytimes.com/2014/03/09/technology/the-youngest-technorati.html?_r=0",
                        @"created_at": @"2014-03-05T22:32:38+00:00",
                        @"updated_at": @"2014-03-05T22:32:38+00:00",
                        @"published_at": @"2014-03-04T19:52:18+00:00"},
                      @{@"id": @8,
                        @"feed_id": @2,
                        @"title": @"1 Billion",
                        @"summary": @"Kickstarter just had the billionth dollar pledged on the platform. The company published a fun infographic of some of their data to celebrate. They included a map of how much each country had pledged total, but they didn’t show where all the money had gone to.",
                        @"image": @"https://s3.amazonaws.com/easy-reader-images/ks1.png",
                        @"url": @"http://blog.milesgrimshaw.com/2014/03/10/1-billion/",
                        @"created_at": @"2014-03-05T22:32:39+00:00",
                        @"updated_at": @"2014-03-05T22:32:39+00:00",
                        @"published_at": @"2014-03-04T19:52:19+00:00"},
                      @{@"id": @9,
                        @"feed_id": @1,
                        @"title": @"iOS 7.1",
                        @"summary": @"iOS 7.1 is packed with interface refinements, bug fixes, improvements, and new features. Apple CarPlay introduces a better way to use iPhone while driving. And you can now control exactly how long Siri listens and more. Getting the update is easy. Go to Settings. Select General. And tap Software Update.",
                        @"image": @"https://s3.amazonaws.com/easy-reader-images/ios1.png",
                        @"url": @"http://www.apple.com/ios/ios7-update/",
                        @"created_at": @"2014-03-05T22:32:40+00:00",
                        @"updated_at": @"2014-03-05T22:32:40+00:00",
                        @"published_at": @"2014-03-04T19:52:20+00:00"},
                      @{@"id": @10,
                        @"feed_id": @2,
                        @"title": @"The Flying Phantom: US$40k sailboat levitates two feet above the waves",
                        @"summary": @"'It’s like removing the handbrake – suddenly everything gets smoother and faster in pure silence.' This gravity-defying US$40k catamaran rises completely out of the water at speed on a pair of hook-shaped hydrofoils. It looks like the work of David Copperfield, but it’s real, and it’s set to start a revolution in the sailing world.",
                        @"image": @"https://s3.amazonaws.com/easy-reader-images/sb1.png",
                        @"url": @"http://www.gizmag.com/flying-phantom-hydrofoil-catamaran-sailing/31143/",
                        @"created_at": @"2014-03-05T22:32:41+00:00",
                        @"updated_at": @"2014-03-05T22:32:41+00:00",
                        @"published_at": @"2014-03-04T19:52:21+00:00"}, nil];
  
  NSRange subarrayRange;
  if ( !self.requestCounter ) self.requestCounter = 1;
  if ( self.requestCounter == 1 ){
    subarrayRange = NSMakeRange(0,4);
  } else {
    subarrayRange = NSMakeRange(self.requestCounter*2,2);
  }
  self.requestCounter++;
  
  return @{@"feed_items": [items subarrayWithRange:subarrayRange]};
}


@end
