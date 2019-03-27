//
//  LXLKeyboardManager.m
//  KeyboardDemo
//
//  Created by admin on 2017/11/7.
//  Copyright © 2017年 李小龙. All rights reserved.
//

#import "LXLKeyboardManager.h"
#import "LXLControllerDataModel.h"
#import "UITextView+LXLExtension.h"
#import "UITextField+LXLExtension.h"
#import "UIViewController+LXLExtension.h"
#import "UIView+LXLFirstResponder.h"

@interface LXLKeyboardManager()

@property (nonatomic, strong) LXLControllerDataModel *lxl_vcDataModel; //用于记录每个VC view初始位置。
@property (nonatomic, strong) NSNotification *lxl_lastKeyboardShowNoti; //上一次键盘显示的通知
@property (nonatomic, assign) UIKeyboardType lxl_lastKayboardType;
@property (nonatomic, weak) UIView *lxl_editingView; //正在编辑的view
@property (nonatomic, assign) BOOL sendKeybaordNoti; //用于记录系统是否已经发出键盘通知，如果没有发出键盘通知（键盘高度未改变时），则在延时后主动调用上一次的键盘通知，触发视图移动

@end



@implementation LXLKeyboardManager


- (instancetype)initWithMonitoredVC:(UIViewController *)monitoredVC {
    self = [super init];
    if(self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(p_keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(p_keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldBeginEditing:) name:UITextFieldTextDidBeginEditingNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewBeginEditing:) name:UITextViewTextDidBeginEditingNotification object:nil];
        
        self.lxl_vcDataModel = [[LXLControllerDataModel alloc] init];
        _lxl_lastKeyboardShowNoti = nil;
        _lxl_lastKayboardType = -1;
        _monitoredVC = monitoredVC;
    }
    return self;
}

- (instancetype)init {
    return [self initWithMonitoredVC:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark ---textField 或 textView 开始编辑
- (void)textFieldBeginEditing:(NSNotification *)noti {
    _sendKeybaordNoti = NO;
    UITextField *textField = (UITextField *)noti.object;
    self.lxl_editingView = textField;
    [self p_keybaordType:textField.keyboardType];
}



- (void)textViewBeginEditing:(NSNotification *)noti {
    _sendKeybaordNoti = NO;
    UITextView *textView = (UITextView *)noti.object;
    self.lxl_editingView = textView;
    [self p_keybaordType:textView.keyboardType];
}

- (void)p_keybaordType:(UIKeyboardType)keyboardType {
    if(_lxl_lastKayboardType == keyboardType) {
        if(_lxl_lastKeyboardShowNoti) { //键盘存在时，且键盘类型未改变时，系统不会发出键盘弹窗通知
            [self p_handelShowKeyboardNofi:_lxl_lastKeyboardShowNoti];
        }
    } else {
        _lxl_lastKayboardType = keyboardType;
        //如果0.1秒后系统未发出键盘改变通知，则调用上一次的键盘通知用于计算当前的键盘高度
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if(!_sendKeybaordNoti && _lxl_lastKeyboardShowNoti) {
                NSLog(@"延迟0.1秒后未收到键盘更改通知");
                [self p_handelShowKeyboardNofi:_lxl_lastKeyboardShowNoti];
            }
        });
//        NSLog(@"textField开始编辑 %ld", _lxl_lastKayboardType);
    }
}



- (void)p_keyboardWillShow:(NSNotification *)noti {

    _sendKeybaordNoti = YES;
    _lxl_lastKeyboardShowNoti = noti;

    if(!_monitoredVC) {
        _monitoredVC = [UIViewController currentShowController];
    }

    if(!self.lxl_vcDataModel.saveVCViewInitialY) { //第一次推出键盘时记录VC view的初始位置
//        NSLog(@"lxl_isInitVCViewY %f", _monitoredVC.view.frame.origin.y);
        self.lxl_vcDataModel.vcViewInitialY = _monitoredVC.view.frame.origin.y;
        self.lxl_vcDataModel.saveVCViewInitialY = YES;
        
    }


    [self p_handelShowKeyboardNofi:noti];
}

#pragma mark ---键盘通知处理
- (void)p_handelShowKeyboardNofi:(NSNotification *)noti {
    CGRect keyboardFrame = [noti.userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    double animationTimes = [noti.userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] doubleValue];
    animationTimes = animationTimes == 0 ? 0.25 : animationTimes;
    if(keyboardFrame.origin.y < [UIApplication sharedApplication].keyWindow.bounds.size.height) { //隐藏键盘时不进行回调
        [self p_changeVCViewFrameKeybaordY:keyboardFrame.origin.y animationTime:animationTimes];
    }
    
}



- (void)p_keyboardWillHide:(NSNotification *)noti {

    _lxl_lastKeyboardShowNoti = nil;
    double animationTimes = [noti.userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] doubleValue];
    [self p_animationWithTime:animationTimes offSetY: self.lxl_vcDataModel.vcViewInitialY];
    
    self.lxl_editingView = nil;
}


#pragma mark ---根据键盘高度移动当前controller的view
- (void)p_changeVCViewFrameKeybaordY:(CGFloat)keyboardY animationTime:(NSTimeInterval)animationTimes{
    
    CGFloat viewBottomDistanceVCViewBottom = 0;
    CGFloat textViewBottomOffSetKeyboardY = -1000;
    

    if([_lxl_editingView isKindOfClass:[UITextView class]]) {
        UITextView *textView = (UITextView *)_lxl_editingView;
        textViewBottomOffSetKeyboardY = textView.lxl_editingViewBottomDistanceKeyboardTop;
        viewBottomDistanceVCViewBottom = [self p_firstResponderViewOffSetY:textView];
    } else if ([_lxl_editingView isKindOfClass:[UITextField class]]) {
        UITextField *textField = (UITextField *)_lxl_editingView;
        textViewBottomOffSetKeyboardY = textField.lxl_editingViewBottomDistanceKeyboardTop;
        viewBottomDistanceVCViewBottom = [self p_firstResponderViewOffSetY:textField];
    }
    
    CGFloat offY; //计算正在编辑的view底部加上间距与键盘顶部的偏移
    if(textViewBottomOffSetKeyboardY == -1000) { //未指定默认值
        offY = keyboardY - viewBottomDistanceVCViewBottom - _monitoredVC.lxl_editingViewBottomDistanceKeyboardTop;
    } else {
        offY = keyboardY - viewBottomDistanceVCViewBottom - textViewBottomOffSetKeyboardY;
    }
    
    
    if(offY <= 0.0) { //上移试图控制器
        CGRect frame = _monitoredVC.view.frame;
        [self p_animationWithTime:animationTimes offSetY:frame.origin.y + offY];
    } else {
//        NSLog(@"offY:%f  viewY:%f  initialY:%f", offY, _monitoredVC.view.frame.origin.y, self.lxl_vcDataModel.vcViewInitialY);
        if(offY + _monitoredVC.view.frame.origin.y < self.lxl_vcDataModel.vcViewInitialY) { //下移视图控制器，下移的位置不能超过初始位置
            CGRect frame = _monitoredVC.view.frame;
            [self p_animationWithTime:animationTimes offSetY:frame.origin.y +  offY];
        } else { //回到初始位置
            [self p_animationWithTime:animationTimes offSetY:self.lxl_vcDataModel.vcViewInitialY];
        }
    }
}


#pragma mark ---计算当前被编辑的view底部距离屏幕顶部的距离
- (CGFloat)p_firstResponderViewOffSetY:(UIView *)editingView {
    
    CGRect textFieldFrame = [_monitoredVC.view convertRect:editingView.frame fromView:editingView.superview]; //计算编辑的正在的view相对VC view的位置
    CGFloat viewOffsetY = textFieldFrame.origin.y + textFieldFrame.size.height + _monitoredVC.view.frame.origin.y; //计算当前view的底部记录屏幕顶部的偏移
    return viewOffsetY;
}


- (void)p_animationWithTime:(NSTimeInterval)duration offSetY:(CGFloat)offY {
    if(_monitoredVC) {
        [self p_monitoredVCAnimationWithTime:duration offSetY:offY];
    }
    if(_offsetBlock) {
        _offsetBlock(duration, offY);
    }
    if(_delegate && [_delegate respondsToSelector:@selector(editingVCViewYPosition:animationTime:)]) {
        [_delegate editingVCViewYPosition:offY animationTime:duration];
    }
}

#pragma mark --- 被监听的VC View开始动画
- (void)p_monitoredVCAnimationWithTime:(NSTimeInterval)duration offSetY:(CGFloat)offY {
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:duration animations:^{
            CGRect frame = _monitoredVC.view.frame;
            frame.origin.y = offY;
            _monitoredVC.view.frame = frame;
        }];
    });
}

@end
