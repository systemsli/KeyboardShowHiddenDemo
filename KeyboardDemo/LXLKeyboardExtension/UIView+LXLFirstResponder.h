//
//  UIView+LXLFirstResponder.h
//  KeyboardDemo
//
//  Created by 李小龙 on 2017/3/6.
//  Copyright © 2017年 李小龙. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (LXLFirstResponder)


/**
 查找第一响应者

 @return 返回第一响应者
 */
- (UIView *)lxlFirstResponder;

@end
