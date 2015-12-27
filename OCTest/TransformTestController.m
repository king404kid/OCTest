//
//  TransformTestController.m
//  OCTest
//
//  Created by Feng on 15/12/12.
//  Copyright (c) 2015年 Feng. All rights reserved.
//

#import "TransformTestController.h"

@interface TransformTestController ()
{
    UIView *yellowView;
    UIView *redView;
    UIView *blueView;
    UIImageView *imageView;
}
@end

@implementation TransformTestController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self layoutUI];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self testTransform];
//    [self testLayerPosition];
//    [self testLayerHierarchy];
//    [self testLayerHierarchy2];
//    [self testTransformAnimation];
//    [self testTransformAnimationWithAutoLayout];
}

#pragma mark - 布局
- (void)layoutUI {
    yellowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    yellowView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:yellowView];
    
    redView = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    redView.backgroundColor = [UIColor redColor];
    [self.view addSubview:redView];
    
    blueView = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    blueView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:blueView];
}

#pragma mark - 测试变换
- (void)testTransform {
    CGAffineTransform blueTransform = blueView.transform;
    CGAffineTransform scaleTransform = CGAffineTransformMakeScale(0.5, 0.5);
    CGAffineTransform translateTransform = CGAffineTransformMakeTranslation(50, 50);
    CGAffineTransform rotateTransform = CGAffineTransformMakeRotation(-M_PI / 6);
    CGAffineTransform transform = CGAffineTransformConcat(translateTransform, scaleTransform);
    NSLog(@"centerX: %f, centerY: %f", blueView.center.x, blueView.center.y);
    NSLog(@"positionX: %f, positionY: %f", blueView.layer.position.x, blueView.layer.position.y);
    NSLog(@"anchorPointX: %f, anchorPointY: %f", blueView.layer.anchorPoint.x, blueView.layer.anchorPoint.y);
    NSLog(@"width: %f, height: %f", blueView.bounds.size.width, blueView.bounds.size.height);
    NSLog(@"f_width: %f, f_height: %f", blueView.frame.size.width, blueView.frame.size.height);
    NSLog(@"---------------------");
    blueView.transform = transform;
    NSLog(@"centerX: %f, centerY: %f", blueView.center.x, blueView.center.y);
    NSLog(@"positionX: %f, positionY: %f", blueView.layer.position.x, blueView.layer.position.y);
    NSLog(@"anchorPointX: %f, anchorPointY: %f", blueView.layer.anchorPoint.x, blueView.layer.anchorPoint.y);
    NSLog(@"width: %f, height: %f", blueView.bounds.size.width, blueView.bounds.size.height);
    NSLog(@"f_width: %f, f_height: %f", blueView.frame.size.width, blueView.frame.size.height);
    
    // 测试结果：transform无论怎办改变，都不会影响view的center，layer的position和anchorPoint，改变的只是view的frame。另外，改变transform的先后顺序是有区别的，例如先改变其translation再改变scale或rotation，和前后者调换，得出来的效果是不一样的。view是根据anchorPoint(相当于图钉)的位置进行调整的
    // 测试结果：关于形变size的测试，即使通过transform缩放，旋转，平移，bounds永远会保持原来大小，而！改变的永远是frame的大小。因为它是通过bounds和形变最终算出来的一个值
    
//    NSLog(@"\n\n\n\n");
//    transform = translateTransform;
//    blueView.transform = transform;
//    NSLog(@"只是平移:\ntranslateX: %f, translateY: %f", blueView.transform.tx, blueView.transform.ty);
//    transform = CGAffineTransformConcat(scaleTransform, translateTransform);
//    blueView.transform = transform;
//    NSLog(@"先缩放再平移:\ntranslateX: %f, translateY: %f", blueView.transform.tx, blueView.transform.ty);
//    transform = CGAffineTransformConcat(translateTransform, scaleTransform);
//    blueView.transform = transform;
//    NSLog(@"先平移再缩放:\ntranslateX: %f, translateY: %f", blueView.transform.tx, blueView.transform.ty);
//    transform = CGAffineTransformConcat(rotateTransform, translateTransform);
//    blueView.transform = transform;
//    NSLog(@"先旋转再平移:\ntranslateX: %f, translateY: %f", blueView.transform.tx, blueView.transform.ty);
//    transform = CGAffineTransformConcat(translateTransform, rotateTransform);
//    blueView.transform = transform;
//    NSLog(@"先平移再旋转:\ntranslateX: %f, translateY: %f", blueView.transform.tx, blueView.transform.ty);
    
    // 测试结果：平移是跟缩放，转动有关的。即使赋值的时候是50，结果不一定是50。而且跟transform的先后顺序有关，具体运行上面注释代码
}

#pragma mark - 测试layer位置
- (void)testLayerPosition {
    NSLog(@"centerX: %f, centerY: %f", blueView.center.x, blueView.center.y);
    NSLog(@"positionX: %f, positionY: %f", blueView.layer.position.x, blueView.layer.position.y);
    NSLog(@"anchorPointX: %f, anchorPointY: %f", blueView.layer.anchorPoint.x, blueView.layer.anchorPoint.y);
    NSLog(@"---------------------");
//    blueView.layer.anchorPoint = CGPointMake(0, 0);
//    blueView.layer.position = CGPointMake(200, 200);
    blueView.center = CGPointMake(200, 200);
    NSLog(@"centerX: %f, centerY: %f", blueView.center.x, blueView.center.y);
    NSLog(@"positionX: %f, positionY: %f", blueView.layer.position.x, blueView.layer.position.y);
    NSLog(@"anchorPointX: %f, anchorPointY: %f", blueView.layer.anchorPoint.x, blueView.layer.anchorPoint.y);
    
    // 测试结果：anchorPoint和position是不会相互影响的，改变其中一边只会对其view的frame造成改变。anchorPoint和position是不同坐标系的，空间上重合的点。通过测试猜想，position跟center是相同的，center只是读取position而已，跟view的frame/bound读取layer的一样
}

#pragma mark - 测试layer层次
- (void)testLayerHierarchy {
    CALayer *layer = blueView.layer.superlayer;
    NSLog(@"%@", layer);
    NSLog(@"%i", blueView.layer.superlayer == redView.layer.superlayer);  // 输出1
    [blueView.layer removeFromSuperlayer];
    NSLog(@"%@", blueView.superview);  // 输出null
    NSLog(@"test");
    
    // view对象有一个显示对象树，而每个view控制着一个layer，与此同时，layer也是有一个对象数，跟view类似，测试中看到，blueView.layer和redView.layer的父类layer是一样的，由此证明猜想正确。而如果从对象树remove的话，也会使得显示不出来，同时view也会被移除对象树
}

#pragma mark - 测试layer层次2
- (void)testLayerHierarchy2 {
    CALayer *subLayer = [CALayer layer];
    subLayer.backgroundColor = [[UIColor orangeColor] CGColor];
    subLayer.bounds = CGRectMake(0, 0, 50, 50);
    subLayer.anchorPoint = CGPointMake(0.5, 0.5);
    subLayer.position = CGPointMake(50, 50);
    [blueView.layer addSublayer:subLayer];
    
    UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    subView.backgroundColor = [UIColor purpleColor];
    [blueView addSubview:subView];
    
    NSLog(@"%i", subView.layer.superlayer == blueView.layer);  // 输出1
    NSLog(@"%i", subView.layer.superlayer == subLayer.superlayer);  // 输出1
    NSLog(@"%lu", (unsigned long)[blueView.layer sublayers].count);  // 输出2
    
    // 研究view树跟layer树的关系。往view的layer里面addSubLayer，此时view和layer->subLayer1。再往view里面addSubView，此时view->subView和layer->subLayer1，layer->subLayer2。从输出可以看到，subLayer1.superLayer是等于subLayer2.superLayer，即view.layer，view.layer的子layer一共有2个。实验表明：layer是不一定有view，但是被加入的view，其对应的layer会对应加入父layer的树结构去
}

#pragma mark - 测试transform animatiom
- (void)testTransformAnimation {
    [yellowView removeFromSuperview];
    [redView removeFromSuperview];
    [blueView removeFromSuperview];
    imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"onepiece"]];
    imageView.frame = CGRectMake(0, 0, 150, 100);
    imageView.contentMode = UIViewContentModeScaleToFill;
    [self.view addSubview:imageView];
    
    // animation
    CGPoint oldCenter = imageView.center;
    CGAffineTransform oldtransform = imageView.transform;
    CGFloat oldAlpha = imageView.alpha;
    [UIView animateWithDuration:2.0 //动画持续时间
                          delay:0.0 //延迟多久执行
                        options: UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState //执行选项：例如动画的过程描述，动画过程是否允许交互等等，比较多，更多参见文档
                     animations:^{
                         //执行的动画的block
                         imageView.center = self.view.center;
                         imageView.transform = CGAffineTransformConcat(CGAffineTransformMakeRotation(M_PI), CGAffineTransformMakeScale(2.0, 2.0));
                         imageView.alpha = 0.5;
                     }
                     completion:^(BOOL finished) {
                         //动画结束后的block
                         imageView.center = oldCenter;
                         imageView.transform = oldtransform;
                         imageView.alpha = oldAlpha;
                     }];
    
    // 通过frame设置的ui，其动画效果比较简单，不需要用layoutIfNeeded
}

#pragma mark - 测试transform animatiom autolayout
- (void)testTransformAnimationWithAutoLayout {
    [yellowView removeFromSuperview];
    [redView removeFromSuperview];
    [blueView removeFromSuperview];
    imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"onepiece"]];
    imageView.contentMode = UIViewContentModeScaleToFill;
    [self.view addSubview:imageView];
    
    // autolayout
    imageView.translatesAutoresizingMaskIntoConstraints = false;
    NSLayoutConstraint *leading = [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:150];
    NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:100];
    NSArray *arr = [NSArray arrayWithObjects:leading, top, width, height, nil];
    [self.view addConstraints:arr];
    [self.view layoutIfNeeded];    // 很关键，即时刷新
    
    // animation
    [UIView animateWithDuration:2.0 //动画持续时间
                          delay:0.0 //延迟多久执行
                        options: UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState //执行选项：例如动画的过程描述，动画过程是否允许交互等等，比较多，更多参见文档
                     animations:^{
                         [self.view removeConstraint:leading];
                         [self.view removeConstraint:top];
                         [self.view addConstraint:centerX];
                         [self.view addConstraint:centerY];
                         //执行的动画的block
                         imageView.transform = CGAffineTransformConcat(CGAffineTransformMakeRotation(M_PI), CGAffineTransformMakeScale(2.0, 2.0));
//                         imageView.transform = CGAffineTransformMakeTranslation(100, 0);
//                         imageView.center = self.view.center;
                         imageView.alpha = 0.5;
                         [self.view layoutIfNeeded];    // 很关键，即时刷新
                     }
                     completion:^(BOOL finished) {
                         [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(reloadUI:) userInfo:nil repeats:false];
                     }];
    
    // 在autolayout下做的动画，注意不能使用frame相关的信息，否则会有“复位”问题。同时，transform问题在这里没有出现，跟网上说法不一致，网上解决方案是：提供一个容器做autolayout，其自身用frame的方式进行动画
}

// 这个版本跟网上提到的不一样，此处在autolayout的情况下，即使使用transform也不会导致动画异常(即使强制刷新也没有影响)。网上说的是transform在autolayout下会导致动画的重绘，影响显示。有可能是skd版本做了修复。但是！！！如果在autolayout的情况下使用frame的布局方式，就绝对会悲剧的。。。
- (void)reloadUI:(NSTimer *)timer {
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
}

@end
