//
//  SwitchSchoolButton.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/8/20.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "SwitchSchoolButton.h"
@implementation SwitchSchoolButton

- (void)layoutSubviews
{
    [super layoutSubviews];
    if(_redDot == nil)
    {
        _redDot = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 6, 6)];
        [_redDot.layer setCornerRadius:3];
        [_redDot.layer setMasksToBounds:YES];
        [_redDot setBackgroundColor:[UIColor colorWithHexString:@"F0003A"]];
        [_redDot setHidden:YES];
        [self addSubview:_redDot];
    }
    [_redDot setCenter:CGPointMake(self.imageView.right, self.imageView.top)];
}

- (void)setHasNew:(BOOL)hasNew
{
    _hasNew = hasNew;
    [_redDot setHidden:!_hasNew];
    [self setNeedsLayout];
}

@end
