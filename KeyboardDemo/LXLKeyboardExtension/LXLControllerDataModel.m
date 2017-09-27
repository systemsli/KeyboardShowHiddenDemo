//
//  LXLControllerDataModel.m
//  KeyboardDemo
//
//  Created by admin on 2017/9/20.
//  Copyright © 2017年 李小龙. All rights reserved.
//

#import "LXLControllerDataModel.h"

@implementation LXLControllerDataModel

- (instancetype)init {
    self = [super init];
    if(self) {
        _vcViewInitialY = 0.0;
        _saveVCViewInitialY = NO;
        _endEditintViewBkColor = [UIColor clearColor];
    }
    return self;
}

@end
