//
//  CSNestableScrollview.m
//  EasyReader
//
//  Created by Joseph Lorich on 4/4/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import "CSNestableScrollView.h"

@implementation CSNestableScrollView

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView* result = [super hitTest:point withEvent:event];
//    id superSuper = [[result superview] superview];
//    
//    if ([superSuper isKindOfClass:[UIWebView class]])
//    {
//        NSLog(@"WEB VIEW");
////      return result;
//        self.scrollEnabled = NO;
//    }
//    else
//    {
//        NSLog(@"SOMETHING ELSE");
//        self.scrollEnabled = YES;
//    }
    return result;
}




//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
//{
//    if (self.contentOffset.y >= self.frame.size.height)
//    {
//        NSLog(@"YES");
//        return YES;
//    }
//    
//    NSLog(@"NO");
//    return NO;
//
////    UIView *superView = [otherGestureRecognizer.view superview];
////    UIView *superSuperView = [superView superview];
////    
////    if ([superView isKindOfClass:[UIWebView class]] || [superSuperView isKindOfClass:[UIWebView class]])
////    {
////      return YES;
////    }
////    else
////    {
////        return NO;
////    }
//}


//- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
//{
//    [super motionBegan:motion withEvent:event];
//}


//
//- (UIResponder *)nextResponder
//{
//    UIResponder *next = [super nextResponder];
//    
//    return next;
//}
//
//- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [super touchesMoved:touches withEvent:event];
//}
//
//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [super touchesBegan:touches withEvent:event];
//}
//
//-(void) touchesEnded: (NSSet *) touches withEvent: (UIEvent *) event
//{
//    // Pass to parent
//    [super touchesEnded:touches withEvent:event];
////    [self.nextResponder touchesEnded:touches withEvent:event];
//}
//
//- (BOOL)canBecomeFirstResponder
//{
//    return YES;
//}

@end
