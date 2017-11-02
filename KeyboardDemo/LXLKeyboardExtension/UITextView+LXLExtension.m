//
//  UITextView+LXLExtension.m
//  KeyboardDemo
//
//  Created by admin on 2017/9/20.
//  Copyright © 2017年 李小龙. All rights reserved.
//

#import "UITextView+LXLExtension.h"
#import <objc/runtime.h>

static const char *lxl_tvBottomOffSetKeyboardTopKey = "lxl_tvBottomOffSetKeyboardTopKey";

@implementation UITextView (LXLExtension)


- (void)setLxl_tvBottomOffSetKeyboardTop:(CGFloat)lxl_tvBottomOffSetKeyboardTop {
    NSNumber *number = [NSNumber numberWithFloat:lxl_tvBottomOffSetKeyboardTop];
    objc_setAssociatedObject(self, lxl_tvBottomOffSetKeyboardTopKey, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)lxl_tvBottomOffSetKeyboardTop {
    NSNumber *number = objc_getAssociatedObject(self, lxl_tvBottomOffSetKeyboardTopKey);
    if(number == nil) {
        return -1000;
    }
    CGFloat offset = number.floatValue <= 0.0 ? 0.0 : number.floatValue;
    return offset;
}

@end
