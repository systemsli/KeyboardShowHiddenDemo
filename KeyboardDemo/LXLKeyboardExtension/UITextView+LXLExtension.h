//
//  UITextView+LXLExtension.h
//  KeyboardDemo
//
//  Created by admin on 2017/9/20.
//  Copyright © 2017年 李小龙. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (LXLExtension)

/**
 设置键盘距离被编辑的view的bottom的距离（默认距离为10）； 如要使用，需先导入此category文件.
 界面销毁时，自动移除键盘监听通知，并结束本界面的编辑状态。设置值时必须大于等于0
 键盘回收需各界面自己处理
 */
@property (nonatomic, assign) CGFloat lxl_bottomOffSetKeyboardTop;

@end
