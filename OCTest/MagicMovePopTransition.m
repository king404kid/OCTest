//
//  MagicMovePopTransition.m
//  OCTest
//
//  Created by Feng on 16/1/12.
//  Copyright (c) 2016年 Feng. All rights reserved.
//

#import "MagicMovePopTransition.h"
#import "NavAnimationTestController.h"
#import "NavDetailViewController.h"
#import "NavCollectionViewCell.h"

@implementation MagicMovePopTransition

#pragma mark - 动画时间
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.3f;
}

#pragma mark - 动画方式
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    //1.获取动画的源控制器和目标控制器
    NavAnimationTestController *toVC = (NavAnimationTestController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    NavDetailViewController *fromVC = (NavDetailViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    
    //2.创建imageView的截图，并把imageView隐藏，造成使用户以为移动的就是imageView的假象
    UIView *snapShotView = [fromVC.image snapshotViewAfterScreenUpdates:false];
    snapShotView.frame = [containerView convertRect:fromVC.image.frame fromView:fromVC.image.superview];
    fromVC.image.hidden = true;
    
    //3.设置目标控制器的位置，并把透明度设为0，在后面的动画中慢慢显示出来变为1
    toVC.view.frame = [transitionContext finalFrameForViewController:toVC];
    toVC.selectedCell.hidden = true;
    fromVC.view.alpha = 1;
    toVC.view.alpha = 0;
    
    //4.都添加到 container 中。注意顺序不能错了
    [containerView insertSubview:toVC.view belowSubview:fromVC.view];
    [containerView addSubview:snapShotView];
    //5.执行动画
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        snapShotView.frame = [containerView convertRect:toVC.selectedCell.image.frame fromView:toVC.selectedCell.image.superview];
        fromVC.view.alpha = 0;
        toVC.view.alpha = 1;
    } completion:^(BOOL finished) {
        fromVC.image.hidden = false;
        toVC.selectedCell.hidden = false;
        [snapShotView removeFromSuperview];
        fromVC.view.alpha = 1;
        //一定要记得动画完成后执行此方法，让系统管理 navigation
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

@end