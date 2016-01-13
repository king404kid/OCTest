//
//  NavDetailViewController.m
//  OCTest
//
//  Created by Feng on 16/1/10.
//  Copyright (c) 2016年 Feng. All rights reserved.
//

#import "NavDetailViewController.h"
#import "NavAnimationTestController.h"
#import "MagicMovePopTransition.h"

@interface NavDetailViewController ()

@end

@implementation NavDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 画图
    CGRect rect = CGRectMake(50, 80, self.view.bounds.size.width-100, self.view.bounds.size.width-100);
    self.image = [[UIImageView alloc] initWithFrame:rect];
    self.image.contentMode = UIViewContentModeScaleToFill;
    [self.view addSubview:self.image];
    
    // 增加手势
    UIScreenEdgePanGestureRecognizer *gest = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(edgePanGesture:)];
    gest.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:gest];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.navigationController.delegate = self;
}

- (void)edgePanGesture:(UIScreenEdgePanGestureRecognizer *)gest {
    //计算手指滑的物理距离（滑了多远，与起始位置无关）
    CGFloat progress = [gest translationInView:self.view].x / self.view.bounds.size.width;
    progress = MIN(1.0, MAX(0, progress));//把这个百分比限制在0~1之间
    
    //当手势刚刚开始，我们创建一个 UIPercentDrivenInteractiveTransition 对象
    if (gest.state == UIGestureRecognizerStateBegan) {
        self.percentDrivenTransition = [[UIPercentDrivenInteractiveTransition alloc]init];
        [self.navigationController popViewControllerAnimated:YES];
    } else if (gest.state == UIGestureRecognizerStateChanged){
        //当手慢慢划入时，我们把总体手势划入的进度告诉 UIPercentDrivenInteractiveTransition 对象。
        [self.percentDrivenTransition updateInteractiveTransition:progress];
    } else if (gest.state == UIGestureRecognizerStateCancelled || gest.state == UIGestureRecognizerStateEnded){
        //当手势结束，我们根据用户的手势进度来判断过渡是应该完成还是取消并相应的调用 finishInteractiveTransition 或者 cancelInteractiveTransition 方法.
        if (progress > 0.5) {
            [self.percentDrivenTransition finishInteractiveTransition];
        } else {
            [self.percentDrivenTransition cancelInteractiveTransition];
        }
        self.percentDrivenTransition = nil;
    }
}

#pragma mark - 自定义转场
- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    if (operation == UINavigationControllerOperationPop && [toVC isKindOfClass:[NavAnimationTestController class]]) {
        MagicMovePopTransition *transition = [[MagicMovePopTransition alloc]init];
        return transition;
    }
    return nil;
}

#pragma mark - 告诉navigationcontroller使用改手势返回
- (id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
    if ([animationController isKindOfClass:[MagicMovePopTransition class]]) {
        return self.percentDrivenTransition;
    }
    return nil;
}

@end