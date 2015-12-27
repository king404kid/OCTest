//
//  Account.h
//  OCTest
//
//  Created by Feng on 15/9/26.
//  Copyright (c) 2015年 Feng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Account : NSObject
{
    @private
    int _a;
    int a;
}

@property (nonatomic, assign) float balance;

- (void)toString;

@end