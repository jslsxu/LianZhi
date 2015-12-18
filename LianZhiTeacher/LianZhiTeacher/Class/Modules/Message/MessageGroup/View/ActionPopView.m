//
//  ActionPopView.m
//  LianZhiTeacher
//
//  Created by jslsxu on 15/8/24.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "ActionPopView.h"
#define kTopMargin              64

static UIButton *coverButton = nil;

@implementation ActionPopView

- (instancetype)initWithImageArray:(NSArray *)imageArray titleArray:(NSArray *)titleArray
{
    self = [super initWithFrame:CGRectMake(kScreenWidth - 140, 64, 140, imageArray.count * 50)];
    if(self)
    {
        _bgImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"ActionBG"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 5, 5, 35)]];
        [_bgImageView setUserInteractionEnabled:YES];
        [_bgImageView setFrame:CGRectMake(0, 2, self.width - 8, self.height - 2)];
        [self addSubview:_bgImageView];
        
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(10, 8, _bgImageView.width - 10 * 2, _bgImageView.height - 9)];
        [_contentView setBackgroundColor:[UIColor clearColor]];
        [_bgImageView addSubview:_contentView];
        
        NSInteger itemHeight = _contentView.height / imageArray.count;
        for (NSInteger i = 0; i < imageArray.count; i++)
        {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTag:i + 1];
            [button addTarget:self action:@selector(onButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [button setFrame:CGRectMake(0, itemHeight * i, _contentView.width, itemHeight)];
            [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
            [button setTitleColor:[UIColor colorWithHexString:@"cccccc"] forState:UIControlStateNormal];
            [button.titleLabel setFont:[UIFont systemFontOfSize:15]];
            [button setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5)];
            [button setImage:[UIImage imageNamed:imageArray[i]] forState:UIControlStateNormal];
            [button setTitle:titleArray[i] forState:UIControlStateNormal];
            [_contentView addSubview:button];
            
            if(i < imageArray.count - 1)
            {
                UIView *sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, itemHeight * (i + 1), _contentView.width, 0.5)];
                [sepLine setBackgroundColor:[UIColor darkGrayColor]];
                [_contentView addSubview:sepLine];
            }
        }
    }
    return self;
}

- (void)show
{
    UIWindow *keywindow = [UIApplication sharedApplication].keyWindow;
    if(coverButton == nil)
        coverButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [coverButton setFrame:keywindow.bounds];
    [coverButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [keywindow addSubview:coverButton];
    
    self.alpha = 0;
    self.origin = CGPointMake(coverButton.width - self.width, kTopMargin + 5);
    [coverButton addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1.f;
        self.y = kTopMargin;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)dismiss
{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.f;
        self.y = kTopMargin + 5;
    } completion:^(BOOL finished) {
        [coverButton removeFromSuperview];
        coverButton = nil;
    }];
}

- (void)onButtonClicked:(UIButton *)button
{
    NSInteger tag = button.tag - 1;
    if([self.delegate respondsToSelector:@selector(popActionViewDidSelectedAtIndex:)])
        [self.delegate popActionViewDidSelectedAtIndex:tag];
    [coverButton removeFromSuperview];
    coverButton = nil;
}


@end
