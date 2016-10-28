//
//  CalendarMonthIndicator.m
//  LianZhiParent
//
//  Created by qingxu zhou on 16/10/28.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "CalendarMonthIndicator.h"

@interface CalendarMonthIndicator ()
@property (nonatomic, strong)UILabel*   monthLabel;
@property (nonatomic, strong)UIButton*  preButton;
@property (nonatomic, strong)UIButton*  nextButton;
@end

@implementation CalendarMonthIndicator

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        _preButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_preButton setImage:[UIImage imageNamed:@"DatePickerPreNormal"] forState:UIControlStateNormal];
        [_preButton setImage:[UIImage imageNamed:@"DatePickerPreDisabled"] forState:UIControlStateDisabled];
        [_preButton setFrame:CGRectMake(0, 0, 30, 30)];
        [_preButton addTarget:self action:@selector(onPre) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_preButton];
        
        _monthLabel = [[UILabel alloc] initWithFrame:CGRectMake(_preButton.right, 0, 160, 30)];
        [_monthLabel setFont:[UIFont systemFontOfSize:14]];
        [_monthLabel setTextColor:[UIColor colorWithHexString:@"333333"]];
        [_monthLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:_monthLabel];
        
        _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nextButton setImage:[UIImage imageNamed:@"DatePickerNextNormal"] forState:UIControlStateNormal];
        [_nextButton setImage:[UIImage imageNamed:@"DatePickerNextDisabled"] forState:UIControlStateDisabled];
        [_nextButton setFrame:CGRectMake(_monthLabel.right, 0, 30, 30)];
        [_nextButton addTarget:self action:@selector(onNext) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_nextButton];
        
        [self setSize:CGSizeMake(_nextButton.right, 30)];
    }
    return self;
}

- (void)setDate:(NSDate *)date{
    _date = date;
    NSDateFormatter *dateFormmater = [[NSDateFormatter alloc] init];
    [dateFormmater setDateFormat:@"yyyy年MM月"];
    [_monthLabel setText:[dateFormmater stringFromDate:_date]];
}

- (void)onPre{
    if([self.delegate respondsToSelector:@selector(calendarPre)]){
        [self.delegate calendarPre];
    }
}

- (void)onNext{
    if([self.delegate respondsToSelector:@selector(calendarNext)]){
        [self.delegate calendarNext];
    }
}

@end
