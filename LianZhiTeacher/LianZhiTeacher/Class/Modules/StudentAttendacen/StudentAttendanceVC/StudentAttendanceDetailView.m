//
//  StudentAttendanceDetailView.m
//  LianZhiTeacher
//
//  Created by jslsxu on 16/1/9.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "StudentAttendanceDetailView.h"

@implementation StudentAttendanceDetailView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if(self)
    {
        _bgButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bgButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchDown];
        [_bgButton setFrame:self.bounds];
        [self addSubview:_bgButton];
        
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(30, (self.height - 400) / 2, self.width - 30 * 2, 400)];
        [self addSubview:_contentView];
        
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelButton setFrame:CGRectMake(_contentView.right - 15, _contentView.y - 15, 30, 30)];
        [cancelButton setImage:[UIImage imageNamed:@"StudentAttendanceClose"] forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancelButton];
    }
    return self;
}

- (void)show
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
    self.alpha = 0.f;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1.f;
    }];
}

- (void)dismiss
{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.f;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
