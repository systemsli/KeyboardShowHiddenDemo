//
//  PushTwoViewController.m
//  KeyboardDemo
//
//  Created by admin on 2017/9/20.
//  Copyright © 2017年 李小龙. All rights reserved.
//

#import "PushTwoViewController.h"
#import "LXLKeyboardManagerHeader.h"


@interface PushTwoViewController ()<LXLKeyboardManagerDelegate>
@property (nonatomic, strong) LXLKeyboardManager *keyboardManager;
@end

@implementation PushTwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.translucent = NO;
    //    self.lxl_addKeyboardObserver = YES;
    _keyboardManager = [[LXLKeyboardManager alloc] init];
    //    _keyboardManager.monitoredVC = self;
    _keyboardManager.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)editingVCViewYPosition:(CGFloat)viewYPosition animationTime:(NSTimeInterval)animationTime {
    [UIView animateWithDuration:animationTime animations:^{
        CGRect frame = self.view.frame;
        frame.origin.y = viewYPosition;
        self.view.frame = frame;
    }];
}

@end
