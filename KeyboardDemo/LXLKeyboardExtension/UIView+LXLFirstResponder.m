//
//  UIView+LXLFirstResponder.m
//  KeyboardDemo
//
//  Created by 李小龙 on 2017/3/6.
//  Copyright © 2017年 李小龙. All rights reserved.
//

#import "UIView+LXLFirstResponder.h"

@implementation UIView (LXLFirstResponder)

- (UIView *)lxlFirstResponder {
    
    if([self isFirstResponder]) {
        return self;
    }
    
    for (UIView *subView in self.subviews) {
        UIView *firstResponder = [subView lxlFirstResponder];
        if(firstResponder) {
            return firstResponder;
        }
    }
    return nil;
    
}

@end
