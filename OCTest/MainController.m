//
//  MainTabBarControllerViewController.m
//  OCTest
//
//  Created by Feng on 15/12/20.
//  Copyright (c) 2015年 Feng. All rights reserved.
//

#import "MainController.h"
#import "TransformTestController.h"
#import "ViewAnimationTestController.h"

@interface MainController ()

@end

@implementation MainController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    TransformTestController *vc1 = [[TransformTestController alloc] init];
    ViewAnimationTestController *vc2 = [[ViewAnimationTestController alloc] init];
    NSArray *ar = @[vc1, vc2];
    NSMutableArray *arD = [NSMutableArray new];
    [ar enumerateObjectsUsingBlock:^(UIViewController *viewController, NSUInteger idx, BOOL *stop) {
         UITabBarItem *item = nil;
         switch (idx) {
             case 0: {
                 item = [[UITabBarItem alloc] initWithTitle:@"transform" image:nil tag:0];
                 break;
             }
             case 1: {
                 item = [[UITabBarItem alloc] initWithTitle:@"animation" image:nil tag:1];
                 break;
             }
         }
         viewController.tabBarItem = item;
         [arD addObject:viewController];
     }];
    self.viewControllers = arD;
    self.selectedIndex = 1;
}

@end
