//
//  NumIndicator.m
//  LianZhiTeacher
//
//  Created by jslsxu on 15/9/11.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "NumIndicator.h"

#define kIndicatorHeight            14

@implementation NumIndicator

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self setBackgroundColor:[UIColor colorWithHexString:@"F0003A"]];
        [self setTextAlignment:NSTextAlignmentCenter];
        [self.layer setCornerRadius:kIndicatorHeight/ 2];
        [self.layer setMasksToBounds:YES];
        [self setFont:[UIFont systemFontOfSize:10]];
        [self setTextColor:[UIColor whiteColor]];
        
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted{
    [super setHighlighted:highlighted];
    [self setBackgroundColor:[UIColor colorWithHexString:@"F0003A"]];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.layer setCornerRadius:self.height / 2];
}

- (void)setIndicator:(NSString *)indicator
{
    _indicator = indicator;
    [self setText:_indicator];
    [self sizeToFit];
    if(indicator.length > 0)
        [self setSize:CGSizeMake(MAX(kIndicatorHeight, self.width + 6), kIndicatorHeight)];
    else
        [self setSize:CGSizeMake(kRedDotSize, kRedDotSize)];
}

@end
