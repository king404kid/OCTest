//
//  ModelFlipTransitionPop.m
//  OCTest
//
//  Created by Feng on 16/1/20.
//  Copyright (c) 2016年 Feng. All rights reserved.
//

#import "ModelFlipTransitionPop.h"
#import "NavDetailViewController.h"
#import "ModelDetailController.h"

@implementation ModelFlipTransitionPop

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.5f;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    ModelDetailController *fromVC = (ModelDetailController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    NavDetailViewController *toVC = (NavDetailViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *container = [transitionContext containerView];
    [container addSubview:toVC.view];
    
    //改变m34
    CATransform3D transfrom = CATransform3DIdentity;
    transfrom.m34 = -0.002;
    container.layer.sublayerTransform = transfrom;
    
    //设置anrchPoint 和 position
    CGRect initalFrame = [transitionContext initialFrameForViewController:fromVC];
    toVC.view.frame = initalFrame;
    toVC.view.layer.anchorPoint = CGPointMake(0, 0.5);
    toVC.view.layer.position = CGPointMake(0, initalFrame.size.height / 2.0);
    toVC.view.layer.transform = CATransform3DMakeRotation(-M_PI_2, 0, 1, 0);
    
    //添加阴影效果
    CAGradientLayer *shadowLayer = [[CAGradientLayer alloc] init];
    shadowLayer.colors = @[(id)[UIColor colorWithWhite:0 alpha:1].CGColor, (id)[UIColor colorWithWhite:0 alpha:0.5].CGColor, (id)[UIColor colorWithWhite:1 alpha:0.5].CGColor];
    shadowLayer.startPoint = CGPointMake(0, 0.5);
    shadowLayer.endPoint = CGPointMake(1, 0.5);
    shadowLayer.frame = initalFrame;
    UIView *shadow = [[UIView alloc] initWithFrame:initalFrame];
    shadow.backgroundColor = [UIColor clearColor];
    [shadow.layer addSublayer:shadowLayer];
    [toVC.view addSubview:shadow];
    shadow.alpha = 1;
    
    //动画
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        toVC.view.layer.transform = CATransform3DIdentity;
        shadow.alpha = 0;
    } completion:^(BOOL finished) {
        toVC.view.layer.anchorPoint = CGPointMake(0.5, 0.5);
        toVC.view.layer.position = CGPointMake(CGRectGetMidX(initalFrame), CGRectGetMidY(initalFrame));
        [shadow removeFromSuperview];
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

@end