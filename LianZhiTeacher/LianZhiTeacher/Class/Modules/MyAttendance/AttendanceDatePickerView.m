//
//  AttendanceDatePickerView.m
//  LianZhiTeacher
//
//  Created by jslsxu on 15/10/7.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "AttendanceDatePickerView.h"

@implementation AttendanceDatePickerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self setBackgroundColor:[UIColor colorWithHexString:@"5ed016"]];
        
        _preButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_preButton setFrame:CGRectMake(45, 0, 30, self.height)];
        [_preButton setImage:[UIImage imageNamed:@"AttendancePickerLeftArrow"] forState:UIControlStateNormal];
        [_preButton addTarget:self action:@selector(onPreButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_preButton];
        
        _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nextButton setFrame:CGRectMake(self.width - 45 - 30, 0, 30, self.height)];
        [_nextButton setImage:[UIImage imageNamed:@"AttendancePickerRightArrow"] forState:UIControlStateNormal];
        [_nextButton addTarget:self action:@selector(onNextButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_nextButton];
        
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(_preButton.right, 0, _nextButton.left - _preButton.right, self.height)];
        [_dateLabel setTextAlignment:NSTextAlignmentCenter];
        [_dateLabel setFont:[UIFont systemFontOfSize:18]];
        [_dateLabel setTextColor:[UIColor whiteColor]];
        [self addSubview:_dateLabel];
        
        [self setDate:[NSDate date]];
    }
    return self;
}

- (void)setDate:(NSDate *)date
{
    _date = date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年MM月"];
    [_dateLabel setText:[formatter stringFromDate:self.date]];
    [_nextButton setEnabled:[self hasNext]];
}

- (void)onPreButtonClicked
{
    NSDate *newdate = [self.date dateByAddingMonths:-1];
    [self setDate:newdate];

    if([self.delegate respondsToSelector:@selector(attendancePickerDidPickAtDate:)])
        [self.delegate attendancePickerDidPickAtDate:self.date];
}

- (void)onNextButtonClicked
{
    NSDate *newdate = [self.date dateByAddingMonths:1];
    if([newdate compare:[NSDate date]] == NSOrderedDescending)
        return;
    
    [self setDate:newdate];
    if([self.delegate respondsToSelector:@selector(attendancePickerDidPickAtDate:)])
        [self.delegate attendancePickerDidPickAtDate:self.date];
}

- (BOOL)hasNext
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *thisStr = [formatter stringFromDate:self.date];
    NSString *curStr = [formatter stringFromDate:[NSDate date]];
    if([thisStr isEqualToString:curStr])
        return NO;
    return YES;
}



@end
