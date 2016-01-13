//
//  NavAnimationTestController.m
//  OCTest
//
//  Created by Feng on 16/1/10.
//  Copyright (c) 2016年 Feng. All rights reserved.
//

#import "NavAnimationTestController.h"
#import "NavDetailViewController.h"
#import "MagicMoveTransition.h"
#import "NavCollectionViewCell.h"

@interface NavAnimationTestController ()
{
    NSArray *dataArr;   // 这里不可以做初始化操作，例如：NSArray *dataArr = nil;是会报错的
}
@end

@implementation NavAnimationTestController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self layoutUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationItem setTitle:@"test"];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.navigationController.delegate = self;
}

#pragma mark - 自定义转场
- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    if (operation == UINavigationControllerOperationPush && [toVC isKindOfClass:[NavDetailViewController class]]) {
        MagicMoveTransition *transition = [[MagicMoveTransition alloc]init];
        return transition;
    }
    return nil;
}

#pragma mark - 布局
- (void)layoutUI {
    dataArr = @[@"onepiece",@"onepiece1",@"onepiece2",@"onepiece3",@"onepiece",@"onepiece"];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGRect rect = CGRectMake(0, 60-44, self.view.bounds.size.width, self.view.bounds.size.height);
    layout.itemSize = CGSizeMake((rect.size.width-60)/2, (rect.size.width-60)/2);
    layout.sectionInset = UIEdgeInsetsMake(0, 20, 0, 20);
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:rect collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor clearColor];
    [collectionView registerClass:[NavCollectionViewCell class] forCellWithReuseIdentifier:@"reuseCellId"];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [self.view addSubview:collectionView];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return dataArr.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NavCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"reuseCellId" forIndexPath:indexPath];
    NSString *content = dataArr[indexPath.row];
    cell.image.image = [UIImage imageNamed:content];
    return cell;
}

#pragma mark - 选择某个cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedCell = (NavCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    NavDetailViewController *detailController = [[NavDetailViewController alloc] init];
    [self.navigationController pushViewController:detailController animated:true];
}

@end