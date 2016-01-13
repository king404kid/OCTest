//
//  SliderViewController.m
//  OCTest
//
//  Created by Feng on 15/12/22.
//  Copyright (c) 2015年 Feng. All rights reserved.
//

#import "SliderViewController.h"

@interface SliderViewController ()
{
    UIView *_mainView;
    UIView *_leftView;
    CGFloat _currentTranslateX;   // 停下来后mainView偏移
    UITapGestureRecognizer *_tapGest;
}
@end

@implementation SliderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initWithSubView];
}

- (void)initWithSubView {
    [self addChildViewController:self.mainController];
    [self addChildViewController:self.leftController];
    _leftView = [[UIView alloc] initWithFrame:self.view.bounds];
    _mainView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_leftView];
    [self.view addSubview:_mainView];
    [_leftView addSubview:self.leftController.view];
    [_mainView addSubview:self.mainController.view];
    
    UIPanGestureRecognizer *panGest = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveViewWithGesture:)];
    [_mainView addGestureRecognizer: panGest];
    panGest.enabled = false;     // 暂时屏蔽左侧栏
    
    UIPanGestureRecognizer *panGest2 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveViewWithGesture:)];
    [_leftView addGestureRecognizer: panGest2];
    panGest2.enabled = false;     // 暂时屏蔽左侧栏
    
    _tapGest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapViewWithGesture:)];
    [_mainView addGestureRecognizer: _tapGest];
    _tapGest.enabled = false;
}

#pragma mark - 手势触摸
- (void)tapViewWithGesture:(UITapGestureRecognizer *)tapGest {
    if (_currentTranslateX > 0) {
        [self showLeft:false];
    }
}

#pragma mark - 手势移动
- (void)moveViewWithGesture:(UIPanGestureRecognizer *)panGest {
    if (panGest.state == UIGestureRecognizerStateBegan) {
//        _currentTranslateX = _mainView.transform.tx;   // 由于平移会受缩放影响，所以不用平移的结果，改为手势结束时记录
    } else if (panGest.state == UIGestureRecognizerStateChanged) {
        CGFloat transX = [panGest translationInView:_mainView].x;
        transX = transX + _currentTranslateX;   // mainView的移动距离
        CGFloat ltransX = (transX - _mainViewOffset)/_mainViewOffset * _leftViewOffset;    // leftView的移动距离
        CGFloat sca = 0;
        CGFloat lsca = 1;
        if (transX > 0) {
            [self configureViewShadowWithDirection:1];
            if (transX < _mainViewOffset) {
//                sca = 1 - (transX/_mainViewOffset) * (1-_scaleScope);
                sca = 1 + transX * (_scaleScope-1) / (_mainViewOffset-0);  // y1=y0+δx*k，这个比上面的公式好理解
                lsca = 1 - sca + _scaleScope;  // scale1+scale2=固定值=1+变化量
            } else {
                lsca = 1;
                sca = _scaleScope;
                ltransX = 0;
                transX = _mainViewOffset;    // 最终定格在右侧位置
            }
            [self changeView:_leftController.contentView scale:lsca transX:ltransX];
        } else {
            if (transX < 0) {
                sca = 1;
                transX = 0;    // 最终定格在左侧位置
            }
        }
        [self changeView:_mainView scale:sca transX:transX];
    } else if (panGest.state == UIGestureRecognizerStateEnded) {
        CGFloat transX = [panGest translationInView:_mainView].x;
        transX = transX + _currentTranslateX;
        // 设置一个范围，如果超过的时候放手则用动画补全
        if (transX > _judgeOffset) {   // 往右移动
            [self showLeft:true];
        } else {   // 往左移动
            [self showLeft:false];
        }
    }
}

/**
 *  显示左边
 *  @param flag true显示左边，false显示主视图
 */
- (void)showLeft:(BOOL)flag {
    if (flag) {   // 显示左边
        [UIView beginAnimations:@"mainStart1" context:nil];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(didStop)];//监听结束的事件
        [self changeView:_mainView scale:_scaleScope transX:_mainViewOffset];
        [self changeView:_leftController.contentView scale:1 transX:0];
        [UIView commitAnimations];
    } else {   // 不显示左边
        [UIView beginAnimations:@"mainStart2" context:nil];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(didStop2)];//监听结束的事件
        [self changeView:_mainView scale:1 transX:0];
        [self changeView:_leftController.contentView scale:_scaleScope transX:-_leftViewOffset];
        [UIView commitAnimations];
    }
}

- (void)didStop {    // 这里发现平移会受到缩放影响，即使赋值275，在缩放的作用下，最终也不会等于275
    NSLog(@"translateX: %f, frameX: %f", _mainView.transform.tx, _mainView.frame.origin.x);
    _currentTranslateX = _mainViewOffset;
    _mainController.view.userInteractionEnabled = false;
    _tapGest.enabled = true;
}

- (void)didStop2 {
    _currentTranslateX = 0;
    _mainController.view.userInteractionEnabled = true;
    _tapGest.enabled = false;
}

#pragma mark - 改变视图transform
- (void)changeView:(UIView *)myView scale:(CGFloat)sca transX:(CGFloat)transX {
    CGAffineTransform transS = CGAffineTransformMakeScale(sca, sca);
    CGAffineTransform transT = CGAffineTransformMakeTranslation(transX, 0);
    CGAffineTransform conT = CGAffineTransformConcat(transT, transS);
    myView.transform = conT;
}

#pragma mark - 增加阴影效果
- (void)configureViewShadowWithDirection:(int)direction
{
    CGFloat shadowW;
    switch (direction) {
        case 0:
            shadowW = 2.0f;
            break;
        case 1:
            shadowW = -2.0f;
            break;
        default:
            break;
    }
    _mainView.layer.shadowOffset = CGSizeMake(shadowW, 1.0);
    _mainView.layer.shadowColor = [UIColor blackColor].CGColor;
    _mainView.layer.shadowOpacity = 0.8f;
}

@end