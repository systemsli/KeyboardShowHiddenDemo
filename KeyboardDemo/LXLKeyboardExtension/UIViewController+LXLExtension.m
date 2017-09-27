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
#import "LXLControllerDataModel.h"
#import "UITextView+LXLExtension.h"
#import "UITextField+LXLExtension.h"

static const char *lxl_keyboardOffsetKey = "lxl_keyboardTopOffEditingViewBottom";
static const char *lxl_addKbObserverKey = "lxl_addKeyboardObserver";
static const char *lxl_vcDataModelKey = "lxl_vcDataModel";
static const char *lxl_addEndEditingViewKey = "lxl_addEndEditingView";
static const char *lxl_endEditingBtnKey = "lxl_endEditingBtn";
static const char *lxl_editingViewKey = "lxl_editingView";

@interface UIViewController ()

@property (nonatomic, strong) LXLControllerDataModel *lxl_vcDataModel; //用于记录每个VC view初始位置。
@property (nonatomic, strong) UIButton *lxl_endEditingBtn;

@property (nonatomic, weak) UIView *lxl_editingView; //正在编辑的view

@end



@implementation UIViewController (LXLExtension)

#pragma mark ---全局变量
NSNotification * lxl_lastKeyboardShowNoti = nil; //上一次键盘显示的通知
NSInteger lxl_lastKayboardType;

#pragma mark ---动态添加的属性
- (void)setLxl_vcDataModel:(LXLControllerDataModel *)lxl_vcDataModel {
    objc_setAssociatedObject(self, lxl_vcDataModelKey, lxl_vcDataModel, OBJC_ASSOCIATION_RETAIN);
}

- (LXLControllerDataModel *)lxl_vcDataModel {
    LXLControllerDataModel *vcDataModel = objc_getAssociatedObject(self, lxl_vcDataModelKey);
    return vcDataModel;
}


- (void)setLxl_keyboardTopOffEditingViewBottom:(CGFloat)lxl_keyboardTopOffEditingViewBottom {
    NSNumber *number = [NSNumber numberWithFloat:lxl_keyboardTopOffEditingViewBottom];
    objc_setAssociatedObject(self, lxl_keyboardOffsetKey, number, OBJC_ASSOCIATION_ASSIGN);
}

- (CGFloat)lxl_keyboardTopOffEditingViewBottom {
    NSNumber *number = objc_getAssociatedObject(self, lxl_keyboardOffsetKey);
    CGFloat offset = number.floatValue <= 0.0 ? 10.0 : number.floatValue;
    return offset;
}



- (void)setLxl_addKeyboardObserver:(BOOL)lxl_addKeyboardObserver {
    NSNumber *number = [NSNumber numberWithBool:lxl_addKeyboardObserver];
    objc_setAssociatedObject(self, lxl_addKbObserverKey, number, OBJC_ASSOCIATION_ASSIGN);
    if(lxl_addKeyboardObserver) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(p_keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(p_keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldBeginEditing:) name:UITextFieldTextDidBeginEditingNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewBeginEditing:) name:UITextViewTextDidBeginEditingNotification object:nil];
        self.lxl_vcDataModel = [[LXLControllerDataModel alloc] init];

    }
}


- (BOOL)lxl_addKeyboardObserver {
    NSNumber *number = objc_getAssociatedObject(self, lxl_addKbObserverKey);
    BOOL added = number.boolValue;
    return added;
}

- (void)setLxl_addEndEditingView:(BOOL)lxl_addEndEditingView {
    NSNumber *number = [NSNumber numberWithBool:lxl_addEndEditingView];
    objc_setAssociatedObject(self, lxl_addEndEditingViewKey, number, OBJC_ASSOCIATION_ASSIGN);
    if(self.lxl_addEndEditingView) {
        if(self.lxl_endEditingBtn == nil) {
            self.lxl_endEditingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            self.lxl_endEditingBtn.backgroundColor = self.lxl_vcDataModel.endEditintViewBkColor;
            self.lxl_endEditingBtn.frame = self.view.bounds;
            [self.lxl_endEditingBtn addTarget:self action:@selector(lxl_clickEndEdit) forControlEvents:UIControlEventTouchUpInside];
            self.lxl_endEditingBtn.hidden = YES;
        }
    }
}

- (BOOL)lxl_addEndEditingView {
    NSNumber *number = objc_getAssociatedObject(self, lxl_addEndEditingViewKey);
    BOOL added = number.boolValue;
    return added;
}

- (void)setLxl_endEditingBtn:(UIButton *)lxl_endEditingBtn {
    objc_setAssociatedObject(self, lxl_endEditingBtnKey, lxl_endEditingBtn, OBJC_ASSOCIATION_RETAIN);
}

- (UIButton *)lxl_endEditingBtn {
    UIButton *btn = objc_getAssociatedObject(self, lxl_endEditingBtnKey);
    return btn;
}

- (void)setLxl_editingView:(UIView *)lxl_editingView {
    objc_setAssociatedObject(self, lxl_editingViewKey, lxl_editingView, OBJC_ASSOCIATION_ASSIGN);
}

- (UIView *)lxl_editingView {
    UIView *editingView = objc_getAssociatedObject(self, lxl_editingViewKey);
    return editingView;
}



#pragma mark ---swizze method
+ (void)load {

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
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


- (void)lxl_dealloc {
    [self.view endEditing:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self lxl_dealloc];
}


#pragma mark ---textField 或 textView 开始编辑
- (void)textFieldBeginEditing:(NSNotification *)noti {
    
    UITextField *textField = (UITextField *)noti.object;
    self.lxl_editingView = textField;
    if(lxl_lastKayboardType == textField.keyboardType) {
        if(lxl_lastKeyboardShowNoti) {
            [self p_keyboardWillShow:lxl_lastKeyboardShowNoti];
        }
    } else {
        lxl_lastKayboardType = textField.keyboardType;
        NSLog(@"textField开始编辑 %ld", lxl_lastKayboardType);
    }
}



- (void)textViewBeginEditing:(NSNotification *)noti {
    
    UITextView *textView = (UITextView *)noti.object;
    self.lxl_editingView = textView;
    if(lxl_lastKayboardType == textView.keyboardType) {
        if(lxl_lastKeyboardShowNoti) {
            [self p_keyboardWillShow:lxl_lastKeyboardShowNoti];
        }
    } else {
        lxl_lastKayboardType = textView.keyboardType;
        NSLog(@"textView开始编辑 %ld", lxl_lastKayboardType);
    }
}



- (void)p_keyboardWillShow:(NSNotification *)noti {

//    NSLog(@"self.view y:%f", self.view.frame.origin.y);
    lxl_lastKeyboardShowNoti = noti;
    if(!self.lxl_vcDataModel.saveVCViewInitialY) { //第一次推出键盘时记录VC view的初始位置
        NSLog(@"lxl_isInitVCViewY %d", self.lxl_vcDataModel.saveVCViewInitialY);
        self.lxl_vcDataModel.vcViewInitialY = self.view.frame.origin.y;
        self.lxl_vcDataModel.saveVCViewInitialY = YES;
    }
    
    CGRect keyboardFrame = [noti.userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    double animationTimes = [noti.userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] doubleValue];
    animationTimes = animationTimes == 0 ? 0.25 : animationTimes;

    [self p_changeVCViewFrameKeybaordY:keyboardFrame.origin.y animationTime:animationTimes];
    if(self.lxl_addEndEditingView) {
        if(self.lxl_endEditingBtn.superview == nil) {
            [self.view addSubview:self.lxl_endEditingBtn];
        }
        self.lxl_endEditingBtn.hidden = NO;
        [self.view bringSubviewToFront:self.lxl_endEditingBtn];
        [UIView animateWithDuration:animationTimes animations:^{
            self.lxl_endEditingBtn.backgroundColor = self.lxl_vcDataModel.endEditintViewBkColor;
        }];
    }
    
    
}

#pragma mark ---根据键盘高度移动当前controller的view
- (void)p_changeVCViewFrameKeybaordY:(CGFloat)keyboardY animationTime:(NSTimeInterval)animationTimes{
    
    CGFloat viewOffSetY = 0;
    CGFloat textViewBottomOffSetKeyboardY = -1000;
    
    UIView *responderView;
    if(self.lxl_editingView) {
        responderView = self.lxl_editingView;
    } else {
        responderView = [self.view lxlFirstResponder];
    }
    if([responderView isKindOfClass:[UITextView class]]) {
        UITextView *textView = (UITextView *)responderView;
        textViewBottomOffSetKeyboardY = textView.lxl_bottomOffSetKeyboardTop;
        viewOffSetY = [self p_firstResponderViewOffSetY:responderView];

    } else if ([responderView isKindOfClass:[UITextField class]]) {
        UITextField *textField = (UITextField *)responderView;
        textViewBottomOffSetKeyboardY = textField.lxl_bottomOffSetKeyboardTop;
        viewOffSetY = [self p_firstResponderViewOffSetY:responderView];

    }
    
    CGFloat offY; //计算正在编辑的view底部加上间距与键盘顶部的偏移
    if(textViewBottomOffSetKeyboardY == -1000) {
        offY = keyboardY - viewOffSetY - self.lxl_keyboardTopOffEditingViewBottom;
    } else {
        offY = keyboardY - viewOffSetY - textViewBottomOffSetKeyboardY;
    }
    
    
    if(offY <= 0.0) { //上移试图控制器
        CGRect frame = self.view.frame;
        [self p_animationWithTime:animationTimes offSetY:frame.origin.y + offY];
    } else {
        if(offY + self.view.frame.origin.y < self.lxl_vcDataModel.vcViewInitialY) { //下移视图控制器，下移的位置不能超过初始位置
            CGRect frame = self.view.frame;
            [self p_animationWithTime:animationTimes offSetY:frame.origin.y +  offY];
        } else { //回到初始位置
            [self p_animationWithTime:animationTimes offSetY:self.lxl_vcDataModel.vcViewInitialY];
        }
    }
}


#pragma mark ---计算当前被编辑的view底部距离屏幕顶部的距离
- (CGFloat)p_firstResponderViewOffSetY:(UIView *)editingView {
    
    CGRect textFieldFrame = [self.view convertRect:editingView.frame fromView:editingView.superview]; //计算编辑的正在的view相对VC view的位置
    CGFloat viewOffsetY = textFieldFrame.origin.y + textFieldFrame.size.height + self.view.frame.origin.y; //计算当前view的底部记录屏幕顶部的偏移
    
    return viewOffsetY;
}


- (void)p_animationWithTime:(NSTimeInterval)duration offSetY:(CGFloat)offY {
    [UIView animateWithDuration:duration animations:^{
        CGRect frame = self.view.frame;
        frame.origin.y = offY;
        self.view.frame = frame;
    }];
}


- (void)lxl_setEndEditingViewBackgroundColor:(UIColor *)bkColor {
    self.lxl_vcDataModel.endEditintViewBkColor = bkColor;
    if(self.lxl_endEditingBtn) {
        [self.lxl_endEditingBtn setBackgroundColor:bkColor];
    }
}



- (void)p_keyboardWillHide:(NSNotification *)noti {
    
    self.lxl_endEditingBtn.hidden = YES;
    self.lxl_endEditingBtn.backgroundColor = [UIColor clearColor];
    lxl_lastKeyboardShowNoti = nil;
    double animationTimes = [noti.userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] doubleValue];
    [self p_animationWithTime:animationTimes offSetY:self.lxl_vcDataModel.vcViewInitialY];
    
}

- (void)lxl_clickEndEdit {
    [self.view endEditing:YES];
}



@end
