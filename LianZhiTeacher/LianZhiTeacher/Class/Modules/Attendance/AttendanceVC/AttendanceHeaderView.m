//
//  AttendanceHeaderView.m
//  LianZhiTeacher
//
//  Created by jslsxu on 16/12/20.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "AttendanceHeaderView.h"

@interface AttendanceHeaderView ()
@property (nonatomic, strong)UIView* progressView;
@property (nonatomic, strong)UILabel* attendancePercentLabel;
@property (nonatomic, strong)UILabel* offPercentLabel;
@property (nonatomic, strong)UILabel* classNumLabel;
@property (nonatomic, strong)UILabel* totalNumLabel;
@property (nonatomic, strong)UILabel* attendanceNumLabel;
@property (nonatomic, strong)UILabel* offNumLabel;
@property (nonatomic, strong)UILabel* uncommitLabel;
@end

@implementation AttendanceHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        UIView* contentView = [[UIView alloc] initWithFrame:CGRectInset(self.bounds, 10, 10)];
        [contentView.layer setCornerRadius:6];
        [contentView.layer setMasksToBounds:YES];
        [contentView setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:contentView];
        
        [self setupContentView:contentView];
    }
    return self;
}

- (void)setupContentView:(UIView *)viewParent{
    UIView* progressBG = [[UIView alloc] initWithFrame:CGRectMake(65, 20, viewParent.width - 65 * 2, 10)];
    [progressBG setBackgroundColor:[UIColor colorWithHexString:@"fc6e82"]];
    [viewParent addSubview:progressBG];
    
    self.progressView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, progressBG.height)];
    [self.progressView setBackgroundColor:kCommonTeacherTintColor];
    [progressBG addSubview:self.progressView];
    
    self.attendancePercentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 4, 50, 40)];
    [self.attendancePercentLabel setFont:[UIFont systemFontOfSize:14]];
    [self.attendancePercentLabel setNumberOfLines:0];
    [self.attendancePercentLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [viewParent addSubview:self.attendancePercentLabel];
    
    self.offPercentLabel = [[UILabel alloc] initWithFrame:CGRectMake(viewParent.width - 60, 5, 50, 40)];
    [self.offPercentLabel setFont:[UIFont systemFontOfSize:14]];
    [self.offPercentLabel setNumberOfLines:0];
    [self.offPercentLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [self.offPercentLabel setTextAlignment:NSTextAlignmentRight];
    [viewParent addSubview:self.offPercentLabel];
    
    UILabel* classNumHintLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, 50, 20)];
    [classNumHintLabel setText:@"班级数:"];
    [classNumHintLabel setFont:[UIFont systemFontOfSize:14]];
    [classNumHintLabel setTextColor:[UIColor colorWithHexString:@"333333"]];
    [viewParent addSubview:classNumHintLabel];
    
    self.classNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, 50, viewParent.width / 2 - 65, 20)];
    [self.classNumLabel setFont:[UIFont systemFontOfSize:14]];
    [self.classNumLabel setTextColor:[UIColor colorWithHexString:@"999999"]];
    [viewParent addSubview:self.classNumLabel];
    
    UILabel* totalNumHintLabel = [[UILabel alloc] initWithFrame:CGRectMake(viewParent.width / 2, 50, 50, 20)];
    [totalNumHintLabel setText:@"总人数:"];
    [totalNumHintLabel setFont:[UIFont systemFontOfSize:14]];
    [totalNumHintLabel setTextColor:[UIColor colorWithHexString:@"333333"]];
    [viewParent addSubview:totalNumHintLabel];
    
    self.totalNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(viewParent.width / 2 + 55, 50, viewParent.width / 2 - 65, 20)];
    [self.totalNumLabel setFont:[UIFont systemFontOfSize:14]];
    [self.totalNumLabel setTextColor:[UIColor colorWithHexString:@"999999"]];
    [viewParent addSubview:self.totalNumLabel];
    
    UILabel* attendanceHintLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 75, 50, 20)];
    [attendanceHintLabel setText:@"出勤:"];
    [attendanceHintLabel setFont:[UIFont systemFontOfSize:14]];
    [attendanceHintLabel setTextColor:[UIColor colorWithHexString:@"333333"]];
    [viewParent addSubview:attendanceHintLabel];
    
    self.attendanceNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, 75, viewParent.width / 2 - 65, 20)];
    [self.attendanceNumLabel setFont:[UIFont systemFontOfSize:14]];
    [self.attendanceNumLabel setTextColor:kCommonTeacherTintColor];
    [viewParent addSubview:self.attendanceNumLabel];
    
    UILabel* offNumHintLabel = [[UILabel alloc] initWithFrame:CGRectMake(viewParent.width / 2, 75, 50, 20)];
    [offNumHintLabel setText:@"缺勤:"];
    [offNumHintLabel setFont:[UIFont systemFontOfSize:14]];
    [offNumHintLabel setTextColor:[UIColor colorWithHexString:@"333333"]];
    [viewParent addSubview:offNumHintLabel];
    
    self.offNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(viewParent.width / 2 + 55, 75, viewParent.width / 2 - 65, 20)];
    [self.offNumLabel setFont:[UIFont systemFontOfSize:14]];
    [self.offNumLabel setTextColor:kRedColor];
    [viewParent addSubview:self.offNumLabel];
    
    self.uncommitLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, viewParent.height - 10 - 20, viewParent.width - 10 * 2, 20)];
    [self.uncommitLabel setFont:[UIFont systemFontOfSize:14]];
    [self.uncommitLabel setTextColor:[UIColor colorWithHexString:@"999999"]];
    [viewParent addSubview:self.uncommitLabel];
}

- (void)setModel:(ClassAttendanceListModel *)model{
    _model = model;
    NSMutableAttributedString* attendancePercentStr = [[NSMutableAttributedString alloc] initWithString:@"出勤率\n" attributes:@{NSForegroundColorAttributeName : kColor_33}];
    [attendancePercentStr appendAttributedString:[[NSAttributedString alloc] initWithString:@"95%" attributes:@{NSForegroundColorAttributeName : kCommonTeacherTintColor}]];
    [self.attendancePercentLabel setAttributedText:attendancePercentStr];
    
    NSMutableAttributedString* offPercentStr = [[NSMutableAttributedString alloc] initWithString:@"缺勤率\n" attributes:@{NSForegroundColorAttributeName : kColor_33}];
    [offPercentStr appendAttributedString:[[NSAttributedString alloc] initWithString:@"5%" attributes:@{NSForegroundColorAttributeName : kRedColor}]];
    [self.offPercentLabel setAttributedText:offPercentStr];
    
    [self.classNumLabel setText:@"10个"];
    [self.totalNumLabel setText:@"1000人"];
    [self.attendanceNumLabel setText:@"900人"];
    [self.offNumLabel setText:@"50人"];
    [self.uncommitLabel setText:@"目前未提交考勤的班级还有1个班"];
}

@end
