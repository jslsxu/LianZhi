//
//  GiftDetailView.m
//  LianZhiTeacher
//
//  Created by jslsxu on 16/1/13.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "GiftDetailView.h"

@implementation GiftDetailView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        _bgView = [[UIView alloc] initWithFrame:self.bounds];
        [_bgView setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.6]];
        [self addSubview:_bgView];
    }
    return self;
}

@end
