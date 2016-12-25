//
//  StudentAttendanceDetailVC.m
//  LianZhiTeacher
//
//  Created by jslsxu on 16/12/21.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "StudentAttendanceDetailVC.h"
#import "Calendar.h"
#import "StudentAttendanceHeaderView.h"
@interface StudentAttendanceDetailVC ()<CalendarDelegate>
@property (nonatomic, strong)Calendar* calendar;
@property (nonatomic, strong)UIScrollView* scrollView;
@property (nonatomic, strong)StudentAttendanceHeaderView* headerView;
@end

@implementation StudentAttendanceDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"ebebeb"]];
    [self setupTitle];
    [self.view addSubview:[self calendar]];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.calendar.height, self.view.width, self.view.height - self.calendar.height)];
    [_scrollView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [_scrollView setAlwaysBounceVertical:YES];
    [_scrollView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:_scrollView];
    
    [_scrollView addSubview:[self headerView]];
    UIView* contentView = [self contentView];
    [contentView setOrigin:CGPointMake(10, self.headerView.bottom + 10)];
    [_scrollView addSubview:contentView];
    [_scrollView setContentSize:CGSizeMake(_scrollView.width, contentView.bottom + 10)];
}

- (void)setupTitle{
    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [titleLabel setNumberOfLines:0];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setTextColor:[UIColor colorWithHexString:@"525252"]];
    NSMutableAttributedString* titleString = [[NSMutableAttributedString alloc] initWithString:@"学生考勤\n" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17]}];
    [titleString appendAttributedString:[[NSAttributedString alloc] initWithString:@"14级01班" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12]}]];
    [titleLabel setAttributedText:titleString];
    [titleLabel sizeToFit];
    [self.navigationItem setTitleView:titleLabel];
}

- (Calendar *)calendar{
    if(_calendar == nil){
        _calendar = [[Calendar alloc] initWithDate:[NSDate date]];
        [_calendar setDelegate:self];
    }
    return _calendar;
}

- (StudentAttendanceHeaderView *)headerView{
    if(nil == _headerView){
        _headerView = [[StudentAttendanceHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.width, 100)];
    }
    return _headerView;
}

- (UIView *)contentView{
    UIView* bgView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, self.view.width - 10 * 2, 0)];
    [bgView setBackgroundColor:[UIColor whiteColor]];
    [bgView.layer setCornerRadius:10];
    [bgView.layer setMasksToBounds:YES];
    
    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [titleLabel setFont:[UIFont systemFontOfSize:15]];
    [titleLabel setTextColor:kColor_33];
    [titleLabel setText:@"当日记录"];
    [titleLabel sizeToFit];
    [titleLabel setOrigin:CGPointMake(10, 10)];
    [bgView addSubview:titleLabel];
    
    UILabel* dateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [dateLabel setTextColor:kCommonTeacherTintColor];
    [dateLabel setFont:[UIFont systemFontOfSize:14]];
    [dateLabel setText:@"2016年4月4日"];
    [dateLabel sizeToFit];
    [dateLabel setOrigin:CGPointMake(bgView.width - 10 - dateLabel.width, 10)];
    [bgView addSubview:dateLabel];
    
    CGFloat spaceYStart = titleLabel.bottom + 10;
    for (NSInteger i = 0; i < 10; i++) {
        UIView* dot = [[UIView alloc] initWithFrame:CGRectMake(10, 0, 6, 6)];
        [dot setBackgroundColor:kCommonTeacherTintColor];
        [dot.layer setCornerRadius:3];
        [dot.layer setMasksToBounds:YES];
        [bgView addSubview:dot];
        
        UILabel* timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [timeLabel setTextColor:kCommonTeacherTintColor];
        [timeLabel setFont:[UIFont systemFontOfSize:14]];
        [timeLabel setText:@"08:10"];
        [timeLabel sizeToFit];
        [timeLabel setOrigin:CGPointMake(dot.right + 10, spaceYStart)];
        [bgView addSubview:timeLabel];
        
        [dot setOrigin:CGPointMake(10, timeLabel.centerY - dot.height / 2)];
        
        UILabel* contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(timeLabel.left, 0, bgView.width - 10 - timeLabel.left, 0)];
        [contentLabel setTextColor:kColor_66];
        [contentLabel setNumberOfLines:0];
        [contentLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [contentLabel setFont:[UIFont systemFontOfSize:14]];
        [contentLabel setText:@"陈琦老师提交未出勤，备注，病好了，来学校了，打卡机记录考勤"];
        [contentLabel sizeToFit];
        [contentLabel setOrigin:CGPointMake(timeLabel.left, timeLabel.bottom + 5)];
        [bgView addSubview:contentLabel];
        
        spaceYStart = contentLabel.bottom + 10;
    }
    
    [bgView setHeight:spaceYStart];
    
    return bgView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
