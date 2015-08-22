//
//  ActionView.m
//  LianZhiParent
//
//  Created by jslsxu on 15/8/22.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "ActionView.h"

@implementation ActionView

- (instancetype)initWithPoint:(CGPoint)point
{
    self = [super initWithFrame:CGRectZero];
    if(self)
    {
        self.point = point;
    }
    return self;
}

@end
