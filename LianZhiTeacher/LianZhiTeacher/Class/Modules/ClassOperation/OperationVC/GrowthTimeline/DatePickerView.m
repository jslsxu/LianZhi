//
//  DatePickerView.m
//  LianZhiTeacher
//
//  Created by jslsxu on 15/1/19.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "DatePickerView.h"

@implementation DatePickerView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        
        CGFloat width = 30;
        
        _preButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_preButton setFrame:CGRectMake( width, (self.height - width) / 2, width, width)];
        [_preButton setImage:[UIImage imageNamed:(@"BlueLeftArrow.png")] forState:UIControlStateNormal];
        [_preButton addTarget:self action:@selector(onPre) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_preButton];
        
        _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nextButton setFrame:CGRectMake(self.width - width - width, (self.height - width) / 2, width, width)];
        [_nextButton setImage:[UIImage imageNamed:(@"BlueRightArrow.png")] forState:UIControlStateNormal];
        [_nextButton addTarget:self action:@selector(onNext) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_nextButton];
        
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(_preButton.right + 10, 0, _nextButton.left - _preButton.right - 10 * 2, self.height)];
        [_dateLabel setTextAlignment:NSTextAlignmentCenter];
        [_dateLabel setBackgroundColor:[UIColor clearColor]];
        [_dateLabel setFont:[UIFont systemFontOfSize:16]];
        [_dateLabel setTextColor:kCommonTeacherTintColor];
        [self addSubview:_dateLabel];
    
        
        [self setDate:[NSDate date]];
        
    }
    return self;
}

- (void)setDate:(NSDate *)date
{
    _date = date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年MM月dd日 EEEE"];
    [_dateLabel setText:[formatter stringFromDate:self.date]];
    [_nextButton setHidden:![self hasNext]];
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

- (void)onPre
{

    NSDate *newdate = [self.date dateByAddingDays:-1];
    [self setDate:newdate];
    if([self.delegate respondsToSelector:@selector(growthDatePickerFinished:)])
        [self.delegate growthDatePickerFinished:self.date];
}

- (void)onNext
{

    NSDate *newdate = [self.date dateByAddingDays:1];
    if([newdate compare:[NSDate date]] == NSOrderedDescending)
        return;
    
    [self setDate:newdate];
    if([self.delegate respondsToSelector:@selector(growthDatePickerFinished:)])
        [self.delegate growthDatePickerFinished:self.date];
}

- (NSString *)dateStr
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    return [formatter stringFromDate:self.date];
}

@end
