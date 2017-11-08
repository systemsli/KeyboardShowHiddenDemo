//
//  UITextField+LXLExtension.m
//  KeyboardDemo
//
//  Created by admin on 2017/9/20.
//  Copyright © 2017年 李小龙. All rights reserved.
//

#import "UITextField+LXLExtension.h"
#import <objc/runtime.h>

@implementation UITextField (LXLExtension)

- (void)setLxl_editingViewBottomDistanceKeyboardTop:(CGFloat)lxl_editingViewBottomDistanceKeyboardTop {
    NSNumber *number = [NSNumber numberWithFloat:lxl_editingViewBottomDistanceKeyboardTop];
    objc_setAssociatedObject(self, @selector(lxl_editingViewBottomDistanceKeyboardTop), number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (CGFloat)lxl_editingViewBottomDistanceKeyboardTop {
    
    NSNumber *number = objc_getAssociatedObject(self, @selector(lxl_editingViewBottomDistanceKeyboardTop));
    if(number) {
        return number ? number.floatValue : 0.0;
    } else {
        return -1000.0;
    }
}





@end
