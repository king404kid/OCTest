//
//  Person.m
//  OCTest
//
//  Created by Feng on 15/9/26.
//  Copyright (c) 2015年 Feng. All rights reserved.
//

#import "Person.h"

@implementation Person

-(void)setAccount:(Account *)account
{
    _account = account;
    [self.account addObserver:self forKeyPath:@"balance" options:NSKeyValueObservingOptionNew context:nil];
    [self.account addObserver:self forKeyPath:@"a" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"balance"]) {
        NSLog(@"keyPath=%@, object=%@, newValue=%.2f, context=%@", keyPath, object, [[change objectForKey:@"new"] floatValue], context);
    } else if ([keyPath isEqualToString:@"a"]) {
        NSLog(@"keyPath=%@, object=%@, newValue=%.2f, context=%@", keyPath, object, [[change objectForKey:@"new"] floatValue], context);
    }
}

- (void)dealloc
{
    [self.account removeObserver:self forKeyPath:@"balance"];
}

@end
