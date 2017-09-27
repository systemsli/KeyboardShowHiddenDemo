//
//  UIViewController+LXLExtension.h
//  KeyboardDemo
//
//  Created by 李小龙 on 2017/3/6.
//  Copyright © 2017年 李小龙. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (LXLExtension)


/**
 是否添加键盘监控事件，默认不添加
 */
@property (nonatomic, assign) BOOL lxl_addKeyboardObserver;

/**
 设置键盘距离被编辑的view的bottom的距离（默认距离为10）； 如要使用，需先导入此category文件.
 界面销毁时，自动移除键盘监听通知，并结束本界面的编辑状态。
 键盘回收需各界面自己处理
 */
@property (nonatomic, assign) CGFloat lxl_keyboardTopOffEditingViewBottom; //键盘距离正在编辑的view的底部的距离,需将lxl_addKeyboardObserver设置为yes后才能起作用



/**
 是否在键盘上方添加结束编辑的view，此view不遮盖navigationbar和tabbar，默认为无颜色
 */
@property (nonatomic, assign) BOOL lxl_addEndEditingView;


/**
 设置结束编辑遮盖view的背景颜色

 @param bkColor 颜色值
 */
- (void)lxl_setEndEditingViewBackgroundColor:(UIColor *)bkColor;


@end
