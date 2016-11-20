//
//  MonthIndicatorView.m
//  YouYao
//
//  Created by jslsxu on 15/6/10.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "MonthIndicatorView.h"

#define kMonthIndicatorWidth            100

@implementation MonthIndicatorView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        CGFloat buttonHeight = 30;
        
        [self setBackgroundColor:[UIColor colorWithHexString:@"5ed016"]];
        _monthLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.width - kMonthIndicatorWidth) / 2, 0, kMonthIndicatorWidth, self.height)];
        [_monthLabel setTextAlignment:NSTextAlignmentCenter];
        [_monthLabel setTextColor:[UIColor whiteColor]];
        [_monthLabel setFont:[UIFont systemFontOfSize:16]];
        [self addSubview:_monthLabel];
        
        _preButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_preButton setImage:[UIImage imageNamed:@"AttendancePickerLeftArrow"] forState:UIControlStateNormal];
        [_preButton addTarget:self action:@selector(onPreButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_preButton setFrame:CGRectMake(_monthLabel.left - buttonHeight, (self.height - buttonHeight) / 2, buttonHeight, buttonHeight)];
        [self addSubview:_preButton];
        
        _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nextButton setImage:[UIImage imageNamed:@"AttendancePickerRightArrow"] forState:UIControlStateNormal];
        [_nextButton addTarget:self action:@selector(onNextButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_nextButton setFrame:CGRectMake(_monthLabel.right, (self.height - buttonHeight) / 2, buttonHeight, buttonHeight)];
        [self addSubview:_nextButton];
        
        self.date = [NSDate date];
    }
    return self;
}

- (BOOL)hasNext
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM"];
    NSString *thisStr = [formatter stringFromDate:self.date];
    NSString *curStr = [formatter stringFromDate:[NSDate date]];
    if([thisStr isEqualToString:curStr])
        return NO;
    return YES;
}

- (void)setDate:(NSDate *)date
{
    _date = date;
    
    NSDateFormatter *formmater = [[NSDateFormatter alloc] init];
    [formmater setDateFormat:@"yyyy年MM月"];
    NSString *monthStr = [formmater stringFromDate:_date];
    [_monthLabel setText:monthStr];
    _nextButton.hidden = ![self hasNext];
}

- (void)onPreButtonClicked
{
    [self setDate:[self.date offsetMonth:-1]];
    if([self.delegate respondsToSelector:@selector(monthIndicatorDidChangeMonth:)])
        [self.delegate monthIndicatorDidChangeMonth:self.date];
}

- (void)onNextButtonClicked
{
    [self setDate:[self.date offsetMonth:1]];
    if([self.delegate respondsToSelector:@selector(monthIndicatorDidChangeMonth:)])
        [self.delegate monthIndicatorDidChangeMonth:self.date];
}
@end
