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
#import "ModelDetailController.h"
#import "ModelFlipTransitionPush.h"
#import "ModelFlipTransitionPop.h"

@interface NavDetailViewController ()
{
    ModelDetailController *modelDetail;
}
@end

@implementation NavDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 画图
    CGRect rect = CGRectMake(50, 80, self.view.bounds.size.width-100, self.view.bounds.size.width-100);
    self.image = [[UIImageView alloc] initWithFrame:rect];
    self.image.contentMode = UIViewContentModeScaleToFill;
    [self.view addSubview:self.image];
    
    // 按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:@"model" forState:UIControlStateNormal];
    btn.frame = CGRectMake(rect.origin.x, rect.origin.y+rect.size.height+50, 100, 20);
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(modelSegue) forControlEvents:UIControlEventTouchUpInside];
    
    // 增加手势
    UIScreenEdgePanGestureRecognizer *gest = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(edgePanGesture:)];
    gest.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:gest];
    
    UIScreenEdgePanGestureRecognizer *gest1 = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(edgePanGesture:)];
    gest1.edges = UIRectEdgeRight;
    [self.view addGestureRecognizer:gest1];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.navigationController.delegate = self;
}

//--------------- navigation segue---------------------

#pragma mark - navigation手势转场
- (void)edgePanGesture:(UIScreenEdgePanGestureRecognizer *)gest {
    //计算手指滑的物理距离（滑了多远，与起始位置无关），两种均可
//    CGFloat progress = [gest translationInView:self.view].x / self.view.bounds.size.width;
    CGFloat progress = [gest translationInView:[UIApplication sharedApplication].keyWindow].x / [UIApplication sharedApplication].keyWindow.bounds.size.width;
//    progress = MIN(1.0, MAX(0, progress));//把这个百分比限制在0~1之间
    UIRectEdge dir;
    if (progress > 0) {
        dir = UIRectEdgeLeft;
    } else {
        dir = UIRectEdgeRight;
        progress = -progress;
    }
    
    //当手势刚刚开始，我们创建一个 UIPercentDrivenInteractiveTransition 对象
    if (gest.state == UIGestureRecognizerStateBegan) {
        self.percentDrivenTransition = [[UIPercentDrivenInteractiveTransition alloc]init];
        if (dir == UIRectEdgeLeft) {
            if (gest.view == self.view) {
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                [self dismissViewControllerAnimated:true completion:nil];
            }
        } else if (dir == UIRectEdgeRight) {
            [self modelSegue];
        }
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

#pragma mark - 自定义 navigation pop
- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    if (operation == UINavigationControllerOperationPop && [toVC isKindOfClass:[NavAnimationTestController class]]) {
        MagicMovePopTransition *transition = [[MagicMovePopTransition alloc]init];
        return transition;
    }
    return nil;
}

#pragma mark - 自定义手势 navigation pop
- (id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
    if ([animationController isKindOfClass:[MagicMovePopTransition class]]) {
        return self.percentDrivenTransition;
    }
    return nil;
}

//--------------- model segue---------------------

#pragma mark - model转场
- (void)modelSegue {
    if (modelDetail == nil) {
        modelDetail = [[ModelDetailController alloc] init];
    }
    modelDetail.transitioningDelegate = self;    // 注意这里不是绑定自己的delegate，而是绑定要转向的
    UIScreenEdgePanGestureRecognizer *gest = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(edgePanGesture:)];
    gest.edges = UIRectEdgeLeft;
    [modelDetail.view addGestureRecognizer:gest];  // 给model加上手势
    [self presentViewController:modelDetail animated:true completion:nil];
}

#pragma mark - 自定义 model present
- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return [[ModelFlipTransionPush alloc] init];
}

#pragma mark - 自定义 model dimiss
- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return [[ModelFlipTransitionPop alloc] init];
}

#pragma mark - 自定义手势 model present
- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator {
    return self.percentDrivenTransition;
}

#pragma mark - 自定义手势 model dimiss
- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator {
    return self.percentDrivenTransition;
}

@end