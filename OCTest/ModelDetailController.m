//
//  ModelDetailController.m
//  OCTest
//
//  Created by Feng on 16/1/18.
//  Copyright (c) 2016年 Feng. All rights reserved.
//

#import "ModelDetailController.h"

@interface ModelDetailController ()

@end

@implementation ModelDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 画图
    CGRect rect = CGRectMake(50, 80, self.view.bounds.size.width-100, self.view.bounds.size.width-100);
    self.image = [[UIImageView alloc] initWithFrame:rect];
    self.image.contentMode = UIViewContentModeScaleToFill;
    [self.view addSubview:self.image];
    self.image.image = [UIImage imageNamed:@"onepiece3"];
    
    // 按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:@"model" forState:UIControlStateNormal];
    btn.frame = CGRectMake(rect.origin.x, rect.origin.y+rect.size.height+50, 100, 20);
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(dismissModelSegue) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - model转场
- (void)dismissModelSegue {
    [self dismissViewControllerAnimated:true completion:nil];
}

// 基本所有的转场相关的手势，动画都是写在上一层，而不是这里

@end