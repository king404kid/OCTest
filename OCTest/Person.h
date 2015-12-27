//
//  Person.h
//  OCTest
//
//  Created by Feng on 15/9/26.
//  Copyright (c) 2015年 Feng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Account.h"

@interface Person : NSObject

@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) Account* account;

@end
