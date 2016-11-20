//
//  DatePickerVC.m
//  RentCar
//
//  Created by jslsxu on 15/3/18.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "VacationDatePickerView.h"

@implementation VacationDatePickerView

- (instancetype)initWithFrame:(CGRect)frame andDate:(NSDate *)date minimumDate:(NSDate *)minDate
{
    self = [super initWithFrame:frame];
    if(self)
    {
        _date = [self formatDate:date];
        _backgroundButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backgroundButton setFrame:self.bounds];
        [_backgroundButton setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
        [_backgroundButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_backgroundButton];
        
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 0)];
        [_contentView setBackgroundColor:[UIColor whiteColor]];
        [self setupContentView:_contentView];
        [self addSubview:_contentView];
        
        if(minDate)
            _datePicker.minimumDate = minDate;
        else
            _datePicker.minimumDate = [NSDate date];
    }
    return self;
}

- (void)setupContentView:(UIView *)viewParent
{
    CGFloat margin = 5;
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmButton addTarget:self action:@selector(onConfirmClicked) forControlEvents:UIControlEventTouchUpInside];
    [confirmButton setTitleColor:[UIColor colorWithHexString:@"2790D4"] forState:UIControlStateNormal];
    [confirmButton.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [viewParent addSubview:confirmButton];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton addTarget:self action:@selector(onCancelClicked) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton setTitleColor:[UIColor colorWithHexString:@"2790D4"] forState:UIControlStateNormal];
    [cancelButton.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [viewParent addSubview:cancelButton];
    
    UIView *sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, 40, viewParent.width, 0.5)];
    [sepLine setBackgroundColor:[UIColor colorWithHexString:@"E0E0E0"]];
    [viewParent addSubview:sepLine];
    
    _datePicker = [[UIDatePicker alloc] init];
    [_datePicker setWidth:viewParent.width];
    [_datePicker setDate:_date];
    [_datePicker setDatePickerMode:UIDatePickerModeDateAndTime];
    [_datePicker setMinuteInterval:30];
    [viewParent addSubview:_datePicker];
    
    [viewParent setHeight:_datePicker.height + 40];
    [cancelButton setFrame:CGRectMake(margin, margin, 50, 30)];
    [confirmButton setFrame:CGRectMake(viewParent.width - margin - 50,margin, 50, 30)];
    [_datePicker setY:40];
}

- (void)show
{
    [_backgroundButton setAlpha:0.f];
    [_contentView setY:self.height];
    [[UIApplication sharedApplication].windows[0] addSubview:self];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [_contentView setY:self.height - _contentView.height];
        [_backgroundButton setAlpha:1.f];
    } completion:^(BOOL finished) {
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    }];
}

- (void)dismiss
{
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [UIView animateWithDuration:0.3f animations:^{
        [_contentView setY:self.height];
        [_backgroundButton setAlpha:0.f];
    } completion:^(BOOL finished) {
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        [self removeFromSuperview];
    }];
}

- (void)onCancelClicked
{
    [self dismiss];
}

- (void)onConfirmClicked
{
    NSDate *selectedDate = _datePicker.date;
    if(self.callBack)
        self.callBack(selectedDate);
    [self dismiss];
}

- (NSDate *)formatDate:(NSDate *)date
{
    //距离date最近的一个半点
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd HH:mm"];
    NSString *dateStr = [formatter stringFromDate:date];
    NSInteger minute = [[dateStr substringWithRange:NSMakeRange(14, 2)] integerValue];
    if(minute < 30 && minute > 0)
    {
        dateStr = [dateStr stringByReplacingCharactersInRange:NSMakeRange(14, 2) withString:@"30"];
        return [formatter dateFromString:dateStr];
    }
    else if(minute > 30 && minute <= 59)
    {
        NSDate *nextDate = [NSDate dateWithTimeInterval:60 * 30 sinceDate:date];
        NSString *nextDateStr = [formatter stringFromDate:nextDate];
        nextDateStr = [nextDateStr stringByReplacingCharactersInRange:NSMakeRange(14, 2) withString:@"00"];
        return [formatter dateFromString:nextDateStr];
    }
    return date;

}

@end
