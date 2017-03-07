//
//  UIViewController+LXLExtension.m
//  KeyboardDemo
//
//  Created by 李小龙 on 2017/3/6.
//  Copyright © 2017年 李小龙. All rights reserved.
//

#import "UIViewController+LXLExtension.h"
#import <objc/runtime.h>
#import "UIView+LXLFirstResponder.h"


static const char *keyboardOffsetKey = "keyboardOffsetEditingViewBottom";

@implementation UIViewController (LXLExtension)

- (CGFloat)lxlKeyboardOffsetEditingViewBottom {
    
    NSNumber *number = objc_getAssociatedObject(self, keyboardOffsetKey);
    CGFloat offset = number.floatValue <= 0.0 ? 10.0 : number.floatValue;
    return offset;
    
}

- (void)setLxlKeyboardOffsetEditingViewBottom:(CGFloat)lxlKeyboardOffsetEditingViewBottom {
    
    NSNumber *number = [NSNumber numberWithFloat:lxlKeyboardOffsetEditingViewBottom];
    objc_setAssociatedObject(self, keyboardOffsetKey, number, OBJC_ASSOCIATION_ASSIGN);
    
}


+ (void)load {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self exchangeMethodWithNew:@"lxl_viewDidLoad" origin:@"viewDidLoad"];
        [self exchangeMethodWithNew:@"lxl_dealloc" origin:@"dealloc"];
    });
    
}


+ (void)exchangeMethodWithNew:(NSString *)newMethodStr origin:(NSString *)originMedthodStr {
    
    Class aClass = [self class];
    
    SEL originSelector = NSSelectorFromString(originMedthodStr);
    SEL newSelector =  NSSelectorFromString(newMethodStr);
    Method originMethod = class_getInstanceMethod(aClass, originSelector);
    Method newMethod = class_getInstanceMethod(aClass, newSelector);
    BOOL didAddMethod = class_addMethod(aClass, originSelector, method_getImplementation(newMethod), method_getTypeEncoding(newMethod));
    
    if(didAddMethod) {
        class_replaceMethod(aClass, originSelector, method_getImplementation(newMethod), method_getTypeEncoding(newMethod));
    } else {
        method_exchangeImplementations(originMethod, newMethod);
    }
    
}




- (void)lxl_viewDidLoad {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lxl_keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lxl_keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self lxl_viewDidLoad];
    
}



- (void)lxl_dealloc {
    //    NSLog(@"dealloc:%@", self);
    [self.view endEditing:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self lxl_dealloc];
}


- (void)lxl_keyboardWillShow:(NSNotification *)noti {
    
    CGFloat viewOffsetY = 0;
    
    id first = [self.view lxlFirstResponder];
    if([first isKindOfClass:[UITextView class]] || [first isKindOfClass:[UITextField class]]) {
        
        UIView *editingView = (UIView *)first;
        CGRect textFieldFrame = [self.view convertRect:editingView.frame fromView:editingView.superview];
        viewOffsetY = textFieldFrame.origin.y + textFieldFrame.size.height;
    }
    
    CGRect keyboardFrame = [noti.userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    double animationTimes = [noti.userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] doubleValue];
    CGFloat offY = keyboardFrame.origin.y - viewOffsetY - self.lxlKeyboardOffsetEditingViewBottom; //
    offY = offY <= 0 ? offY : 0;
    [UIView animateWithDuration:animationTimes animations:^{
        CGRect frame = self.view.frame;
        frame.origin.y = offY;
        self.view.frame = frame;
    }];
    
}


- (void)lxl_keyboardWillHide:(NSNotification *)noti {
    
    double animationTimes = [noti.userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] doubleValue];
    [UIView animateWithDuration:animationTimes animations:^{
        CGRect frame = self.view.frame;
        frame.origin.y = 0;
        self.view.frame = frame;
    }];
    
}


@end
