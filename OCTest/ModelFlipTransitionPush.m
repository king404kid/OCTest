//
//  ModelFlipTransionPush.m
//  OCTest
//
//  Created by Feng on 16/1/18.
//  Copyright (c) 2016年 Feng. All rights reserved.
//

#import "ModelFlipTransitionPush.h"
#import "NavDetailViewController.h"
#import "ModelDetailController.h"

@implementation ModelFlipTransionPush

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.5f;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    NavDetailViewController *fromVC = (NavDetailViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    ModelDetailController *toVC = (ModelDetailController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *container = [transitionContext containerView];
    [container addSubview:toVC.view];
    [container bringSubviewToFront:fromVC.view];
    
    //改变m34
    CATransform3D transfrom = CATransform3DIdentity;
    transfrom.m34 = -0.002;
    container.layer.sublayerTransform = transfrom;
    
    //设置anrchPoint 和 position
    CGRect initalFrame = [transitionContext initialFrameForViewController:fromVC];
    toVC.view.frame = initalFrame;
    fromVC.view.frame = initalFrame;
    fromVC.view.layer.anchorPoint = CGPointMake(0, 0.5);
    fromVC.view.layer.position = CGPointMake(0, initalFrame.size.height / 2.0);
    
    //添加阴影效果
    CAGradientLayer *shadowLayer = [[CAGradientLayer alloc] init];
    shadowLayer.colors = @[(id)[UIColor colorWithWhite:0 alpha:1].CGColor, (id)[UIColor colorWithWhite:0 alpha:0.5].CGColor, (id)[UIColor colorWithWhite:1 alpha:0.5].CGColor];
    shadowLayer.startPoint = CGPointMake(0, 0.5);
    shadowLayer.endPoint = CGPointMake(1, 0.5);
    shadowLayer.frame = initalFrame;
    UIView *shadow = [[UIView alloc] initWithFrame:initalFrame];
    shadow.backgroundColor = [UIColor clearColor];
    [shadow.layer addSublayer:shadowLayer];
    [fromVC.view addSubview:shadow];
    shadow.alpha = 0;
    
    //动画
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        fromVC.view.layer.transform = CATransform3DMakeRotation(-M_PI_2, 0, 1, 0);
        shadow.alpha = 1.0;
    } completion:^(BOOL finished) {
        fromVC.view.layer.anchorPoint = CGPointMake(0.5, 0.5);
        fromVC.view.layer.position = CGPointMake(CGRectGetMidX(initalFrame), CGRectGetMidY(initalFrame));
        fromVC.view.layer.transform = CATransform3DIdentity;
        [shadow removeFromSuperview];
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

@end