//
//  UITextField+LXLExtension.m
//  KeyboardDemo
//
//  Created by admin on 2017/9/20.
//  Copyright © 2017年 李小龙. All rights reserved.
//

#import "UITextField+LXLExtension.h"
#import <objc/runtime.h>

static const char *lxl_tfBottomOffSetKeyboardTopKey = "lxl_tfBottomOffSetKeyboardTop";

@implementation UITextField (LXLExtension)


- (void)setLxl_tfBottomOffSetKeyboardTop:(CGFloat)lxl_tfBottomOffSetKeyboardTop {
    NSNumber *number = [NSNumber numberWithFloat:lxl_tfBottomOffSetKeyboardTop];
    objc_setAssociatedObject(self, lxl_tfBottomOffSetKeyboardTopKey, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)lxl_tfBottomOffSetKeyboardTop {
    NSNumber *number = objc_getAssociatedObject(self, lxl_tfBottomOffSetKeyboardTopKey);
    if(number == nil) {
        return -1000;
    }
    CGFloat offset = number.floatValue <= 0.0 ? 0.0 : number.floatValue;
    return offset;
}





@end
