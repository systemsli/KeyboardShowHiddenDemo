//
//  UITextView+LXLExtension.m
//  KeyboardDemo
//
//  Created by admin on 2017/9/20.
//  Copyright © 2017年 李小龙. All rights reserved.
//

#import "UITextView+LXLExtension.h"
#import <objc/runtime.h>

static const char *lxl_bottomOffSetKeyboardTopKey = "lxl_bottomOffSetKeyboardTop";

@implementation UITextView (LXLExtension)

- (void)setLxl_bottomOffSetKeyboardTop:(CGFloat)lxl_bottomOffSetKeyboardTop {
    NSNumber *number = [NSNumber numberWithFloat:lxl_bottomOffSetKeyboardTop];
    objc_setAssociatedObject(self, lxl_bottomOffSetKeyboardTopKey, number, OBJC_ASSOCIATION_ASSIGN);
}

- (CGFloat)lxl_bottomOffSetKeyboardTop {
    NSNumber *number = objc_getAssociatedObject(self, lxl_bottomOffSetKeyboardTopKey);
    if(number == nil) {
        return -1000;
    }
    CGFloat offset = number.floatValue <= 0.0 ? 0.0 : number.floatValue;
    return offset;
}
@end
