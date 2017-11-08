//
//  UIViewController+LXLExtension.m
//  KeyboardDemo
//
//  Created by 李小龙 on 2017/3/6.
//  Copyright © 2017年 李小龙. All rights reserved.
//

#import "UIViewController+LXLExtension.h"
#import <objc/runtime.h>


@implementation UIViewController (LXLExtension)


- (void)setLxl_editingViewBottomDistanceKeyboardTop:(CGFloat)lxl_editingViewBottomDistanceKeyboardTop {
    NSNumber *number = [NSNumber numberWithFloat:lxl_editingViewBottomDistanceKeyboardTop];
    objc_setAssociatedObject(self, @selector(lxl_editingViewBottomDistanceKeyboardTop), number, OBJC_ASSOCIATION_ASSIGN);
}

- (CGFloat)lxl_editingViewBottomDistanceKeyboardTop {
    NSNumber *number = objc_getAssociatedObject(self, @selector(lxl_editingViewBottomDistanceKeyboardTop));
    if(!number) {
        return 10.0;
    } else {
        return number.floatValue >= 0.0 ? number.floatValue : 10.0;
    }
}

+ (UIViewController *)currentShowController {
    return [self p_topViewController];
}


+ (UIViewController *)p_topViewController {
    UIViewController *resultVC;
    resultVC = [self p_topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self p_topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}

+ (UIViewController *)p_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self p_topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self p_topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}

@end
