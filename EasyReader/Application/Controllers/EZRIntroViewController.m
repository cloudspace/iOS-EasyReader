//
//  EZRIntroViewController.m
//  EasyReader
//
//  Created by John Li on 6/8/15.
//  Copyright (c) 2015 Cloudspace. All rights reserved.
//

#import "EZRIntroViewController.h"
#import "EZRHomeViewController.h"
#import <TwitterKit/TwitterKit.h>

@interface EZRIntroViewController ()

@property (nonatomic,strong) IBOutlet UIButton *btnTwitterLogin;

@end

@implementation EZRIntroViewController

- (void) viewDidLoad
{
    TWTRLogInButton *logInButton = [TWTRLogInButton buttonWithLogInCompletion:^(TWTRSession *session, NSError *error) {
        if(error){
            //TODO
            return;
        }
        [self loadTweetsWithSession:session];
    }];
    
    CGFloat offsetFromBottom = 12;
    logInButton.center =  CGPointMake(self.view.center.x, (self.view.bounds.origin.y + self.view.bounds.size.height) - (logInButton.bounds.size.height * .5f + offsetFromBottom));
    [self.view addSubview:logInButton];
}

- (void)loadTweetsWithSession:(TWTRSession*)twitterSession {
    //  TODO based on session info, check if user exists in Filtacular
    //  if YES
    //    load data using the user and linky_looier
    //  else
    //    load data from /tweets?filter[linky_looier]=1
    //  Go to home screen.
    
    [self pushToHomeScreen];
}

- (void) pushToHomeScreen{
    UIStoryboard* storyboard_home;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        storyboard_home = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:[NSBundle mainBundle]];
    } else {
        storyboard_home = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:[NSBundle mainBundle]];
    }
    EZRHomeViewController *homeViewController = [storyboard_home instantiateViewControllerWithIdentifier:@"Home"];
    [self.navigationController pushViewController:homeViewController animated:true];
}


@end

