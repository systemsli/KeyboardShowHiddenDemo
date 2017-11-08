//
//  InputViewController.m
//  KeyboardDemo
//
//  Created by 李小龙 on 2017/3/6.
//  Copyright © 2017年 李小龙. All rights reserved.
//

#import "InputViewController.h"
#import "LXLKeyboardManagerHeader.h"

@interface InputViewController ()<UITableViewDelegate, UITableViewDataSource, LXLKeyboardManagerDelegate>

@property (nonatomic, strong) LXLKeyboardManager *keyboardManager;

@end

@implementation InputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //    self.lxl_addKeyboardObserver = YES;
    _keyboardManager = [[LXLKeyboardManager alloc] init];
    //    _keyboardManager.monitoredVC = self;
    _keyboardManager.delegate = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)dis:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    return cell;
}


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
