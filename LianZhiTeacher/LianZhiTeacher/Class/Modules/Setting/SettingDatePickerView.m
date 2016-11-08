//
//  DatePickerView.m
//  LianZhiParent
//
//  Created by jslsxu on 15/2/3.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "SettingDatePickerView.h"


@implementation SettingDatePickerView
- (instancetype)initWithType:(SettingDatePickerType)pickerType
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if(self)
    {
        self.pickerType = pickerType;
        [self setBackgroundColor:[UIColor clearColor]];
        _coverButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_coverButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [_coverButton setFrame:self.bounds];
        [self addSubview:_coverButton];
        
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0,self.height, self.width, 0)];
        [_contentView setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:_contentView];
        
        UIView *sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _contentView.width, 1)];
        [sepLine setBackgroundColor:[UIColor colorWithHexString:@"666666"]];
        [_contentView addSubview:sepLine];
        
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor colorWithHexString:@"fc6e82"] forState:UIControlStateNormal];
        [_cancelButton setTitleColor:kCommonTeacherTintColor forState:UIControlStateHighlighted];
        [_cancelButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_cancelButton setFrame:CGRectMake(0, 0, 60, 36)];
        [_contentView addSubview:_cancelButton];
        
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmButton setFrame:CGRectMake(self.width - 60, (36 - 20) / 2, 50, 20)];
        [_confirmButton addTarget:self action:@selector(dateCalueChanged) forControlEvents:UIControlEventTouchUpInside];
        [_confirmButton setBackgroundImage:[UIImage imageWithColor:kCommonTeacherTintColor size:_confirmButton.size cornerRadius:10] forState:UIControlStateNormal];
        [_confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        [_confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_confirmButton setTitleColor:kCommonTeacherTintColor forState:UIControlStateHighlighted];
        [_confirmButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_contentView addSubview:_confirmButton];
    
        _datePicker = [[UIDatePicker alloc] init];
        [_datePicker setBackgroundColor:[UIColor whiteColor]];
        if(self.pickerType == SettingDatePickerTypeDate)
            [_datePicker setDatePickerMode:UIDatePickerModeDate];
        else
            [_datePicker setDatePickerMode:UIDatePickerModeTime];
        [_datePicker setWidth:_contentView.width];
        [_datePicker setY:36];
        [_contentView addSubview:_datePicker];
        [_contentView setHeight:36 + _datePicker.height];
    }
    return self;
}


- (void)show
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        [self setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
        [_contentView setY:self.height - _contentView.height];
    }];
}

- (void)dismiss
{
    [UIView animateWithDuration:0.3 animations:^{
        [self setBackgroundColor:[UIColor clearColor]];
        [_contentView setY:self.height];
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
- (void)dateCalueChanged
{
    NSDate *date = [_datePicker date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if(self.pickerType == SettingDatePickerTypeDate)
        [formatter setDateFormat:@"yyyy-MM-dd"];
    else
        [formatter setDateFormat:@"hh:mm"];
    if(self.blk)
        self.blk([formatter stringFromDate:date]);
    [self dismiss];
}

@end
