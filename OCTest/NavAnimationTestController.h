//
//  NavAnimationTestController.h
//  OCTest
//
//  Created by Feng on 16/1/10.
//  Copyright (c) 2016年 Feng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NavCollectionViewCell;

@interface NavAnimationTestController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource, UINavigationControllerDelegate>

@property (readwrite, retain, nonatomic) NavCollectionViewCell *selectedCell;

@end
