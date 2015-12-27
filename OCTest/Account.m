//
//  Account.m
//  OCTest
//
//  Created by Feng on 15/9/26.
//  Copyright (c) 2015年 Feng. All rights reserved.
//

#import "Account.h"

@implementation Account

- (void)setBalance:(float)balance
{
    _balance = balance;
//    NSLog(@"test balance");
}

- (void)toString
{
    NSLog(@"Account member: _a=%i", _a);
    NSLog(@"Account member: a=%i", a);
}

@end
