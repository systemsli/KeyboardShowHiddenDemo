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
 设置键盘距离被编辑的view的bottom的距离（默认距离为10）； 如要使用，需先导入此category文件.
 界面销毁时，自动移除键盘监听通知，并结束本界面的编辑状态。
 键盘回收需各界面自己处理
 */
@property (nonatomic, assign) CGFloat lxl_editingViewBottomDistanceKeyboardTop; //键盘距离正在编辑的view的底部的距离,需将lxl_addKeyboardObserver设置为yes后才能起作用



/**
 找出屏幕上显示的VC

 @return 当前显示的VC
 */
+ (UIViewController *)currentShowController;


@end
