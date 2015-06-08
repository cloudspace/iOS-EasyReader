//
//  EZRIntroViewController.m
//  EasyReader
//
//  Created by John Li on 6/8/15.
//  Copyright (c) 2015 Cloudspace. All rights reserved.
//

#import "EZRIntroViewController.h"
#import <TwitterKit/TwitterKit.h>

@interface EZRIntroViewController ()

@property (nonatomic,strong) IBOutlet UIButton *btnTwitterLogin;

@end

@implementation EZRIntroViewController

- (void) viewDidLoad
{
    TWTRLogInButton *logInButton = [TWTRLogInButton buttonWithLogInCompletion:^(TWTRSession *session, NSError *error) {
        // play with Twitter session
    }];
    logInButton.center = self.view.center;
    [self.view addSubview:logInButton];
}

- (IBAction)tapTwitterLogin {
    [[Twitter sharedInstance] logInWithCompletion:^(TWTRSession *session, NSError *error) {
        if (session) {
            NSLog(@"signed in as %@", [session userName]);
            [self loginToFiltacular:session];
        } else {
            NSLog(@"error: %@", [error localizedDescription]);
        }
    }];
}

- (void)loginToFiltacular:(TWTRSession*)twitterSession {
    
    //[self.navigationController pushViewController:vcTwitterFeed animated:true];
    return;
}

@end
