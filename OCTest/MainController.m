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
#import "NavAnimationTestController.h"

@interface MainController ()

@end

@implementation MainController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    TransformTestController *vc1 = [[TransformTestController alloc] init];
    ViewAnimationTestController *vc2 = [[ViewAnimationTestController alloc] init];
    NavAnimationTestController *vc3 = [[NavAnimationTestController alloc] init];
    UINavigationController *vc4 = [[UINavigationController alloc] initWithRootViewController:vc3];
    NSArray *ar = @[vc1, vc2, vc4];
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
             case 2: {
                 item = [[UITabBarItem alloc] initWithTitle:@"segue" image:nil tag:1];
                 break;
             }
         }
         viewController.tabBarItem = item;
         [arD addObject:viewController];
     }];
    self.viewControllers = arD;
    self.selectedIndex = 2;
}

@end
