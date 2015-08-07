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
        
        _datePicker = [[UIDatePicker alloc] init];
        [_datePicker setBackgroundColor:[UIColor whiteColor]];
        [_datePicker addTarget:self action:@selector(dateCalueChanged) forControlEvents:UIControlEventValueChanged];
        if(self.pickerType == SettingDatePickerTypeDate)
            [_datePicker setDatePickerMode:UIDatePickerModeDate];
        else
            [_datePicker setDatePickerMode:UIDatePickerModeTime];
        [_datePicker setY:self.height];
        [self addSubview:_datePicker];
        
        _coverButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_coverButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [_coverButton setFrame:CGRectMake(0, 0, self.width, self.height - _datePicker.height)];
        [self addSubview:_coverButton];
            
    }
    return self;
}


- (void)show
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        [self setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
        [_datePicker setY:self.height - _datePicker.height];
    }];
}

- (void)dismiss
{
    [UIView animateWithDuration:0.3 animations:^{
        [self setBackgroundColor:[UIColor clearColor]];
        [_datePicker setY:self.height];
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
}

@end
