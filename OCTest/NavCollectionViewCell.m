//
//  NavCollectionViewCell.m
//  OCTest
//
//  Created by Feng on 16/1/10.
//  Copyright (c) 2016年 Feng. All rights reserved.
//

#import "NavCollectionViewCell.h"

@implementation NavCollectionViewCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.image.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:self.image];
    }
    return self;
}

@end