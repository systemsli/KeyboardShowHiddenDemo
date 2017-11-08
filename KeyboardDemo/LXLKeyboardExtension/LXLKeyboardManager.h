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
@property (nonatomic, weak) id<LXLKeyboardManagerDelegate>delegate;

- (instancetype)initWithMonitoredVC:(UIViewController *)monitoredVC;


@end
