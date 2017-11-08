//
//  PushOneViewController.m
//  KeyboardDemo
//
//  Created by admin on 2017/9/20.
//  Copyright © 2017年 李小龙. All rights reserved.
//

#import "PushOneViewController.h"
#import "LXLKeyboardManagerHeader.h"

@interface PushOneViewController ()
@property (weak, nonatomic) IBOutlet UITextField *oneTF;
@property (weak, nonatomic) IBOutlet UITextField *twoTF;

@property (nonatomic, strong) LXLKeyboardManager *keyboardManager;

@end

@implementation PushOneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.translucent = YES;
//    self.lxl_editingViewBottomDistanceKeyboardTop = YES;
    _oneTF.lxl_editingViewBottomDistanceKeyboardTop = 100;
    _twoTF.lxl_editingViewBottomDistanceKeyboardTop = 50;

    _keyboardManager = [[LXLKeyboardManager alloc] init];
    //    _keyboardManager.monitoredVC = self;
    __weak typeof(self) weakSelf = self;
    _keyboardManager.offsetBlock = ^(double animationTime, CGFloat yPosition) {
        NSLog(@"%f   %f", animationTime, yPosition);
        [weakSelf p_animationWithTime:animationTime offSetY:yPosition];
    };

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

- (void)p_animationWithTime:(NSTimeInterval)duration offSetY:(CGFloat)offY {
    [UIView animateWithDuration:duration animations:^{
        CGRect frame = self.view.frame;
        frame.origin.y = offY;
        self.view.frame = frame;
    }];
}

@end
