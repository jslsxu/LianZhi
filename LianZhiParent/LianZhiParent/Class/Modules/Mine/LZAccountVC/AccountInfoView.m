//
//  AccountInfoView.m
//  LianZhiTeacher
//
//  Created by jslsxu on 16/1/13.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "AccountInfoView.h"

@implementation AccountData
- (void)parseData:(TNDataWrapper *)dataWrapper
{
    
}

@end

@implementation AccountInfoView

- (instancetype)initWithAccountData:(AccountData *)data
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if(self)
    {
        _bgView = [[UIView alloc] initWithFrame:self.bounds];
        [_bgView setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.6]];
        [self addSubview:_bgView];
        
        _contentView = [[UIView alloc] initWithFrame:CGRectZero];
        [self addSubview:_contentView];
    }
    return self;
}

- (void)show
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void)dismiss
{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.f;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
