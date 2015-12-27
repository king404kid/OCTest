//
//  LeftViewController.m
//  OCTest
//
//  Created by Feng on 15/12/22.
//  Copyright (c) 2015年 Feng. All rights reserved.
//

#import "LeftViewController.h"

@interface LeftViewController ()

@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self layoutUI];
}

#pragma mark - 布局
- (void)layoutUI {
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [self.view addSubview:_contentView];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"onepiece"]];
    imageView.contentMode = UIViewContentModeScaleToFill;
    CGRect rect = self.view.bounds;
    imageView.frame = CGRectMake(0, 200, rect.size.width, 200);
    [_contentView addSubview:imageView];
}

@end
