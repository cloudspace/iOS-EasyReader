//
//  EZRSearchBar.m
//  EasyReader
//
//  Created by Joseph Lorich on 4/10/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import "EZRSearchBar.h"

static dispatch_once_t pred;

@implementation EZRSearchBar
{
    /// A reference to the inner text field.  Used to hold the memoized result.
    UITextField *textField;
}

- (UITextField *)textField
{
    dispatch_once(&pred, ^{
        for (UIView *subview in self.subviews) {
            if([subview conformsToProtocol:@protocol(UITextInputTraits)]) {
                textField = (UITextField *)subview;
                return;
            } else {
                for(UIView *subSubview in [subview subviews]) {
                    if([subSubview conformsToProtocol:@protocol(UITextInputTraits)]) {
                        textField = (UITextField *)subSubview;
                        return;
                    }
                }
            }
        }
    });
    
    return textField;
}

@end
