//
//  LXLKeyboardManager.h
//  KeyboardDemo
//
//  Created by admin on 2017/11/7.
//  Copyright © 2017年 李小龙. All rights reserved.
//

#import <UIKit/UIKit.h>



/**
 偏移回调block


 @param animationTime animationTime 动画时间
 @param yPosition 偏移后VC View所在的位置
 */
typedef void(^LXLKeyboardManagerBlock)(NSTimeInterval animationTime, CGFloat yPosition);


@protocol LXLKeyboardManagerDelegate <NSObject>
@optional


/**
 弹出键盘时的回调

 @param viewYPosition 偏移后VC View所在的位置
 @param animationTime animationTime 动画时间
 */
- (void)editingVCViewYPosition:(CGFloat)viewYPosition animationTime:(NSTimeInterval)animationTime;

@end


@interface LXLKeyboardManager : NSObject


/**
 被监控的VC
 */
@property (nonatomic, weak) UIViewController *monitoredVC; //可不设置，在弹出键盘时会自动设置

/**
 编辑textField 或 textView时的回调block
 */
@property (nonatomic, copy) LXLKeyboardManagerBlock offsetBlock;


/**
 回调代理设置
 */
@property (nonatomic, weak) id<LXLKeyboardManagerDelegate>delegate;


/**
 初始化方法，使用此初始化方法后，可不设置代理，在管理类中执行动画

 @param monitoredVC 进行键盘监听的VC
 @return <#return value description#>
 */
- (instancetype)initWithMonitoredVC:(UIViewController *)monitoredVC;


@end
