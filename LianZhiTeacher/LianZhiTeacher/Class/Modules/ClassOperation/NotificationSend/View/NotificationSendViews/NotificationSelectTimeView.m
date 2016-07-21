//
//  NotificationSelectTimeView.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/7/20.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "NotificationSelectTimeView.h"

@implementation NotificationSelectTimeView

+ (void)showWithCompletion:(void (^)(NSDate *))completion{
    NotificationSelectTimeView *selectTimeView = [[NotificationSelectTimeView alloc] init];
    [selectTimeView setCompletion:completion];
    [selectTimeView show];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    if(self){
        _bgButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bgButton setFrame:self.bounds];
        [_bgButton setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.6]];
        [_bgButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_bgButton];
        
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height, self.width, 0)];
        [self setupContentView:_contentView];
        [self addSubview:_contentView];
    }
    return self;
}

- (void)setupContentView:(UIView *)viewParent{
    [viewParent setBackgroundColor:[UIColor whiteColor]];
    UIView *toolView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewParent.width, 36)];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setFrame:CGRectMake(0, 0, 60, toolView.height)];
    [cancelButton setTitleColor:kCommonTeacherTintColor forState:UIControlStateNormal];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [cancelButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [toolView addSubview:cancelButton];
    
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [doneButton setFrame:CGRectMake(toolView.width - 60, 0, 60, toolView.height)];
    [doneButton setTitleColor:kCommonTeacherTintColor forState:UIControlStateNormal];
    [doneButton setTitle:@"确定" forState:UIControlStateNormal];
    [doneButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [doneButton addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
    [toolView addSubview:doneButton];
    
    [viewParent addSubview:toolView];
    
    _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, toolView.bottom, viewParent.width, 0)];
    [_datePicker setMinimumDate:[NSDate date]];
    [_datePicker setDatePickerMode:UIDatePickerModeDateAndTime];
    [viewParent addSubview:_datePicker];
    [viewParent setHeight:36 + _datePicker.height];
}

- (void)confirm{
    if(self.completion){
        self.completion(_datePicker.date);
    }
    [self dismiss];
}

- (void)show{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    _bgButton.alpha = 0.f;
    [UIView animateWithDuration:0.3 animations:^{
        _bgButton.alpha = 1.f;
        _contentView.y = self.height - _contentView.height;
    }completion:^(BOOL finished) {
        
    }];
}

- (void)dismiss{
    [UIView animateWithDuration:0.3 animations:^{
        _bgButton.alpha = 0.f;
        _contentView.y = self.height;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
