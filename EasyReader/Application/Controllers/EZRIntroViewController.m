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
        [self loginToFiltacular:session];
    }];
    
    CGFloat offsetFromBottom = 12;
    logInButton.center =  CGPointMake(self.view.center.x, (self.view.bounds.origin.y + self.view.bounds.size.height) - (logInButton.bounds.size.height * .5f + offsetFromBottom));
    [self.view addSubview:logInButton];
}

- (void)loginToFiltacular:(TWTRSession*)twitterSession {
    UIStoryboard* storyboard_home;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        storyboard_home = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:[NSBundle mainBundle]];
    } else {
        storyboard_home = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:[NSBundle mainBundle]];
    }
    EZRHomeViewController *vcHome = [storyboard_home instantiateViewControllerWithIdentifier:@"Home"];
    [self.navigationController pushViewController:vcHome animated:true];
    return;
}

@end
