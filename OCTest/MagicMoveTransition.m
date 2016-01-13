//
//  MagicMoveTransition.m
//  OCTest
//
//  Created by Feng on 16/1/11.
//  Copyright (c) 2016年 Feng. All rights reserved.
//

#import "MagicMoveTransition.h"
#import "NavAnimationTestController.h"
#import "NavDetailViewController.h"
#import "NavCollectionViewCell.h"

@implementation MagicMoveTransition

#pragma mark - 动画时间
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.3f;
}

#pragma mark - 动画方式
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    //1.获取动画的源控制器和目标控制器
    NavDetailViewController *toVC = (NavDetailViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    NavAnimationTestController *fromVC = (NavAnimationTestController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    
    //2.创建一个 Cell 中 imageView 的截图，并把 imageView 隐藏，造成使用户以为移动的就是 imageView 的假象
    NavCollectionViewCell *cell = fromVC.selectedCell;
    UIView *snapShotView = [cell.image snapshotViewAfterScreenUpdates:false];
    snapShotView.frame = [containerView convertRect:cell.image.frame fromView:cell.image.superview];
    cell.hidden = true;
    
    //3.设置目标控制器的位置，并把透明度设为0，在后面的动画中慢慢显示出来变为1
    toVC.view.frame = [transitionContext finalFrameForViewController:toVC];
    toVC.view.alpha = 0;
    fromVC.view.alpha = 1;
    
    //4.都添加到 container 中。注意顺序不能错了
    [containerView addSubview:toVC.view];
    [containerView addSubview:snapShotView];
    
    //5.执行动画
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        snapShotView.frame = [containerView convertRect:toVC.image.frame fromView:toVC.image.superview];
        toVC.view.alpha = 1;
        fromVC.view.alpha = 0;
    } completion:^(BOOL finished) {
        cell.hidden = false;
        toVC.image.image = cell.image.image;
        [snapShotView removeFromSuperview];
        fromVC.view.alpha = 1;
        //一定要记得动画完成后执行此方法，让系统管理 navigation
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

@end