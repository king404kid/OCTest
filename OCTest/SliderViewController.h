//
//  SliderViewController.h
//  OCTest
//
//  Created by Feng on 15/12/22.
//  Copyright (c) 2015年 Feng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainController.h"
#import "LeftViewController.h"

@interface SliderViewController : UIViewController

@property (readwrite, retain) MainController *mainController;
@property (readwrite, retain) LeftViewController *leftController;
@property (readwrite, assign) int mainViewOffset;
@property (readwrite, assign) int leftViewOffset;
@property (readwrite, assign) int judgeOffset;
@property (readwrite, assign) double scaleScope;

@end