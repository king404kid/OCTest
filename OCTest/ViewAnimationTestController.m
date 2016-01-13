//
//  ViewAnimationTestController.m
//  OCTest
//
//  Created by Feng on 15/12/20.
//  Copyright (c) 2015年 Feng. All rights reserved.
//

#import "ViewAnimationTestController.h"

@interface ViewAnimationTestController ()
{
    UIView *containerView;
    UIImageView *imageView;
    UIImageView *imageView2;
}
@end

@implementation ViewAnimationTestController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self layoutUI];
}

#pragma mark - 布局
- (void)layoutUI {
    containerView = [[UIView alloc] init];
    containerView.frame = CGRectMake(0, 0, 150, 100);
    [self.view addSubview:containerView];
    
    imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"onepiece"]];
    imageView.contentMode = UIViewContentModeScaleToFill;
    imageView.frame = CGRectMake(0, 0, 150, 100);
    [containerView addSubview:imageView];
    imageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"onepiece2"]];
    imageView2.contentMode = UIViewContentModeScaleToFill;
    imageView2.frame = CGRectMake(0, 0, 150, 100);
    [containerView addSubview:imageView2];
    imageView2.hidden = true;
    
    CGFloat itemNum = 6;
    CGFloat itemWidth = 80;
    CGFloat itemHeight = 26;
    CGRect rect = CGRectMake((self.view.bounds.size.width-itemWidth*itemNum)/(itemNum+1), self.view.bounds.size.height-itemHeight-64, itemWidth, itemHeight);
    
    for (int i = 0; i < itemNum; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        [btn setTitle:[NSString stringWithFormat:@"动画%i", i+1] forState:UIControlStateNormal];
        btn.frame = CGRectMake(rect.origin.x+(rect.origin.x+rect.size.width)*i, rect.origin.y, rect.size.width, rect.size.height);
        [self.view addSubview:btn];
        [btn addTarget:self action:NSSelectorFromString([NSString stringWithFormat:@"animation%i:", i+1]) forControlEvents:UIControlEventTouchUpInside];
    }
}

#pragma mark - 动画1
- (void)animation1:(UIButton *)button {
    CGPoint oldCenter = containerView.center;
    CGAffineTransform oldtransform = containerView.transform;
    CGFloat oldAlpha = containerView.alpha;
    [UIView animateWithDuration:2.0 //动画持续时间
                          delay:0.0 //延迟多久执行
                        options: UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState //执行选项：例如动画的过程描述，动画过程是否允许交互等等，比较多，更多参见文档
                     animations:^{
                         //执行的动画的block
                         containerView.center = self.view.center;
                         containerView.transform = CGAffineTransformConcat(CGAffineTransformMakeRotation(M_PI), CGAffineTransformMakeScale(2.0, 2.0));
                         containerView.alpha = 0.5;
                     }
                     completion:^(BOOL finished) {
                         //动画结束后的block
                         containerView.center = oldCenter;
                         containerView.transform = oldtransform;
                         containerView.alpha = oldAlpha;
                     }];
    
    // 最常用的动画，改变frame，transform属性
}

#pragma mark - 动画2
- (void)animation2:(UIButton *)button {
    [UIView beginAnimations:@"Animate 2" context:nil];
    //配置动画的执行属性
    [UIView setAnimationDelay:0.5];//延迟时间
    [UIView setAnimationDelegate:self];
    [UIView setAnimationWillStartSelector:@selector(willStart)];//监听开始的事件
    [UIView setAnimationDidStopSelector:@selector(didStop)];//监听结束的事件
    [UIView setAnimationDuration:2.0];//执行时间
    [UIView setAnimationRepeatAutoreverses:YES];//自动复原
    [UIView setAnimationRepeatCount:1.5];//重复次数
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];//执行的加速过程（加速开始，减速结束）
    [UIView setAnimationBeginsFromCurrentState:YES];//是否由当前动画状态开始执行（处理同一个控件上一次动画还没有结束，这次动画就要开始的情况）
    //实际执行的动画
    containerView.center = self.view.center;
    containerView.transform = CGAffineTransformConcat(CGAffineTransformMakeRotation(M_PI), CGAffineTransformMakeScale(2.0, 2.0));
    containerView.alpha = 0.5;
    //提交动画
    [UIView commitAnimations];
    
    // 个人比较少用此写法，也是改变frame，transform属性
}
-(void)willStart{
    NSLog(@"will start");
}
-(void)didStop{
    NSLog(@"did stop");
}

#pragma mark - 动画3
- (void)animation3:(UIButton *)button {
    [UIView beginAnimations:@"AnimateInContainView" context:nil];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:containerView cache:YES];
    [UIView setAnimationDuration:1.0];
    imageView.hidden = !imageView.hidden;
    imageView2.hidden = !imageView2.hidden;
    [UIView commitAnimations];
    
    // 切换subview的显示，通过动画不显得那么突兀。既可以用hidden，也可以remove
}

#pragma mark - 动画4
- (void)animation4:(UIButton *)button {
    [UIView transitionWithView:containerView
                      duration:1.0
                       options:UIViewAnimationOptionTransitionCurlUp
                    animations:^{
                        imageView.hidden = !imageView.hidden;
                        imageView2.hidden = !imageView2.hidden;
                    }
                    completion:^(BOOL finished) {
                        
                    }];
    
    // 切换subview的显示，通过动画不显得那么突兀。既可以用hidden，也可以remove。而且这里要注意一下，需要一个containerView包住他们，否则就会连通父view一起动画
}

#pragma mark - 动画5
- (void)animation5:(UIButton *)button {
    static BOOL showFirst = true;
    imageView2.hidden = false;
    [containerView sendSubviewToBack:imageView2];
    [UIView transitionFromView:(showFirst ? imageView : imageView2)
                        toView:(showFirst ? imageView2 : imageView)
                      duration:1.0
                       options:(showFirst ? UIViewAnimationOptionTransitionFlipFromRight :
                                UIViewAnimationOptionTransitionFlipFromLeft)
                    completion:^(BOOL finished) {
                        showFirst = !showFirst;
                        [containerView insertSubview:showFirst ? imageView2 : imageView atIndex:0];
                    }];
    
    // 这个函数会用toView来替换FrameView，FromView会从原来的父类移除。而且这里要注意一下，需要一个containerView包住他们，否则就会连通父view一起动画
}

#pragma mark - 动画6
- (void)animation6:(UIButton *)button {
    [UIView animateKeyframesWithDuration:5 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:0.15 animations:^{
            containerView.transform = CGAffineTransformMakeRotation(M_PI * -1.5);
        }];
        [UIView addKeyframeWithRelativeStartTime:0.15 relativeDuration:0.1 animations:^{
            containerView.transform = CGAffineTransformMakeRotation(M_PI * 1.0);
        }];
        [UIView addKeyframeWithRelativeStartTime:0.25 relativeDuration:0.2 animations:^{
            containerView.transform = CGAffineTransformMakeRotation(M_PI * 1.3);
        }];
        [UIView addKeyframeWithRelativeStartTime:0.45 relativeDuration:0.2 animations:^{
            containerView.transform = CGAffineTransformMakeRotation(M_PI * 0.8);
        }];
        [UIView addKeyframeWithRelativeStartTime:0.65 relativeDuration:0.35 animations:^{
            //旋转后掉落
            //最后一步，视图淡出并消失
            CGAffineTransform shift =
            CGAffineTransformMakeTranslation(180.0, 0.0);
            CGAffineTransform rotate =
            CGAffineTransformMakeRotation(M_PI * 0.3);
            containerView.transform = CGAffineTransformConcat(shift, rotate);
            containerView.alpha = 0.0;
        }];
    } completion:^(BOOL finished) {
        containerView.transform = CGAffineTransformIdentity;
        containerView.alpha = 1.0;
    }];
}

@end
