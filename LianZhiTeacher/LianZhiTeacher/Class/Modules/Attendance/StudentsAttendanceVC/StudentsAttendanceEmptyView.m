//
//  StudentsAttendanceEmptyView.m
//  LianZhiTeacher
//
//  Created by jslsxu on 17/1/4.
//  Copyright © 2017年 jslsxu. All rights reserved.
//

#import "StudentsAttendanceEmptyView.h"

@interface StudentsAttendanceEmptyView ()
@property (nonatomic, strong)UIImageView* bgView;
@property (nonatomic, strong)UILabel* dateLabel;
@property (nonatomic, strong)UILabel* stateLabel;
@property (nonatomic, strong)UIButton* startButton;
@end

@implementation StudentsAttendanceEmptyView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self setBackgroundColor:[UIColor whiteColor]];
        self.bgView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"emptyDangriWeikaoqin"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 120, 0)]];
        [self.bgView setFrame:CGRectMake((self.width - 114) / 2, 0, 114, (self.height + 100) / 2)];
        [self addSubview:self.bgView];
    
        
        self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.bgView.width - 80) / 2, self.bgView.height - 50 - 35, 80, 20)];
        [self.dateLabel setTextAlignment:NSTextAlignmentCenter];
        [self.dateLabel setTextColor:kColor_66];
        [self.dateLabel setFont:[UIFont systemFontOfSize:15]];
        [self.bgView addSubview:self.dateLabel];
        
        self.stateLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.bgView.width - 80) / 2, self.bgView.height - 55, 80, 20)];
        [self.stateLabel setTextAlignment:NSTextAlignmentCenter];
        [self.stateLabel setTextColor:[UIColor whiteColor]];
        [self.stateLabel setFont:[UIFont systemFontOfSize:15]];
        [self.bgView addSubview:self.stateLabel];
        
        self.startButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.startButton addTarget:self action:@selector(onStartClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.startButton setFrame:CGRectMake((self.width - 80) / 2, self.bgView.bottom + 20, 80, 30)];
        [self.startButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [self.startButton setTitle:@"开始考勤" forState:UIControlStateNormal];
        [self.startButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.startButton setBackgroundImage:[UIImage imageWithColor:kCommonTeacherTintColor size:self.startButton.size cornerRadius:3] forState:UIControlStateNormal];
        [self addSubview:self.startButton];
        [self.startButton setHidden:YES];
        
    }
    return self;
}

- (void)layoutSubviews{
    [UIView animateWithDuration:0.3 animations:^{
        [self.bgView setHeight:(self.height + 100) / 2];
        [self.dateLabel setFrame:CGRectMake((114 - 80) / 2, self.bgView.height - 50 - 35, 80, 20)];
        [self.stateLabel setFrame:CGRectMake((114 - 80) / 2, self.bgView.height - 55, 80, 20)];
        [self.startButton setY:self.bgView.bottom + 20];
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
    NSString* imageStr = nil;
    if(result == NSOrderedAscending){//之前
        [self.stateLabel setText:@"当日未考勤"];
        imageStr = @"emptyDangriWeikaoqin";
    }
    else if(result == NSOrderedSame){
        [self.stateLabel setText:@"今日未考勤"];
        [self.startButton setHidden:NO];
        imageStr = @"emptyTodayWeikaoqin";
    }
    else{
        [self.stateLabel setText:@"日期未到达"];
        imageStr = @"emptyMeiDaoda";
    }
    [self.bgView setImage:[[UIImage imageNamed:imageStr] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 120, 0)]];
}

- (void)onStartClicked{
    if(self.editAttendanceCallback){
        self.editAttendanceCallback();
    }
}

@end
