//
//  NavDetailViewController.h
//  OCTest
//
//  Created by Feng on 16/1/10.
//  Copyright (c) 2016年 Feng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NavDetailViewController : UIViewController<UINavigationControllerDelegate, UIViewControllerTransitioningDelegate>

@property (readwrite, retain, nonatomic) UIImageView *image;
@property (readwrite, retain, nonatomic) UIPercentDrivenInteractiveTransition *percentDrivenTransition;

@end