//
//  ExchangeChildrenView.m
//  LianZhiParent
//
//  Created by jslsxu on 15/10/30.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "ExchangeChildrenView.h"

@implementation ExchangeChildrenView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if(self)
    {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake((self.width - 240) / 2, (self.height - 110) / 2, 240, 110)];
        [_contentView setBackgroundColor:kCommonParentTintColor];
        [_contentView.layer setCornerRadius:20];
        [_contentView.layer setMasksToBounds:YES];
        [self addSubview:_contentView];
        
        
    }
    return self;
}

@end
