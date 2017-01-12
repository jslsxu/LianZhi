//
//  StudentsAttendanceEmptyView.m
//  LianZhiTeacher
//
//  Created by jslsxu on 17/1/4.
//  Copyright © 2017年 jslsxu. All rights reserved.
//

#import "StudentsAttendanceEmptyView.h"

@interface StudentsAttendanceEmptyView ()
@property (nonatomic, strong)UIView* vLine;
@property (nonatomic, strong)UIView* contentView;
@property (nonatomic, strong)UIView* stateBG;
@property (nonatomic, strong)UILabel* dateLabel;
@property (nonatomic, strong)UILabel* stateLabel;
@property (nonatomic, strong)UIButton* startButton;
@end

@implementation StudentsAttendanceEmptyView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
    
        self.vLine = [[UIView alloc] initWithFrame:CGRectMake(self.width / 2, 0, kLineHeight, 100)];
        [self.vLine setBackgroundColor:kSepLineColor];
        [self addSubview:self.vLine];
        
        self.contentView = [[UIView alloc] initWithFrame:CGRectMake((self.width - 100) / 2, self.vLine.bottom, 100, 100)];
        [self.contentView.layer setCornerRadius:50];
        [self.contentView.layer setBorderWidth:kLineHeight];
        [self.contentView.layer setBorderColor:kSepLineColor.CGColor];
        [self.contentView.layer setMasksToBounds:YES];
        [self addSubview:self.contentView];
        
        self.stateBG = [[UIView alloc] initWithFrame:CGRectMake(0, 50, self.contentView.width, 50)];
        [self.stateBG setBackgroundColor:[UIColor colorWithHexString:@""]];
        [self.contentView addSubview:self.stateBG];
        
        self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, self.contentView.width, 35)];
        [self.dateLabel setTextAlignment:NSTextAlignmentCenter];
        [self.dateLabel setTextColor:kColor_66];
        [self.dateLabel setFont:[UIFont systemFontOfSize:15]];
        [self.contentView addSubview:self.dateLabel];
        
        self.stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, self.contentView.width, 35)];
        [self.stateLabel setTextAlignment:NSTextAlignmentCenter];
        [self.stateLabel setTextColor:[UIColor whiteColor]];
        [self.stateLabel setFont:[UIFont systemFontOfSize:15]];
        [self.contentView addSubview:self.stateLabel];
        
        self.startButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.startButton addTarget:self action:@selector(onStartClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.startButton setFrame:CGRectMake((self.width - 80) / 2, self.contentView.bottom + 20, 80, 30)];
        [self.startButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [self.startButton setTitle:@"开始考勤" forState:UIControlStateNormal];
        [self.startButton setTitleColor:[UIColor colorWithHexString:@"ff8884"] forState:UIControlStateNormal];
        [self.startButton.layer setBorderColor:[UIColor colorWithHexString:@"ff8884"].CGColor];
        [self.startButton.layer setBorderWidth:1];
        [self.startButton.layer setCornerRadius:4];
        [self.startButton.layer setMasksToBounds:YES];
        [self addSubview:self.startButton];
        [self.startButton setHidden:YES];
        
    }
    return self;
}

- (void)layoutSubviews{
    [UIView animateWithDuration:0.3 animations:^{
        [self.contentView setCenter:CGPointMake(self.width / 2, self.height / 2)];
        [self.vLine setHeight:self.contentView.y];
        [self.startButton setY:self.contentView.bottom + 20];
    }];
}

- (void)setDate:(NSDate *)date{
    _date = date;
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString* dateString = [formatter stringFromDate:_date];
    NSString* todayString = [formatter stringFromDate:[NSDate date]];
    NSComparisonResult result = [dateString compare:todayString];
    [self.dateLabel setText:[_date stringWithFormat:@"MM月dd日"]];
    [self.startButton setHidden:YES];
    if(result == NSOrderedAscending){//之前
        [self.stateLabel setText:@"当日未考勤"];
        [self.stateBG setBackgroundColor:[UIColor colorWithHexString:@"ff8884"]];
    }
    else if(result == NSOrderedSame){
        [self.stateLabel setText:@"今日未考勤"];
        [self.stateBG setBackgroundColor:[UIColor colorWithHexString:@"ff9626"]];
        [self.startButton setHidden:NO];
    }
    else{
        [self.stateLabel setText:@"日期未到达"];
        [self.stateBG setBackgroundColor:[UIColor colorWithHexString:@"90c337"]];
    }
}

- (void)onStartClicked{
    if(self.editAttendanceCallback){
        self.editAttendanceCallback();
    }
}

@end
