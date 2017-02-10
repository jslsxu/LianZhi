//
//  AttendanceHeaderView.m
//  LianZhiTeacher
//
//  Created by jslsxu on 16/12/20.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "AttendanceHeaderView.h"

@interface AttendanceHeaderView ()
@property (nonatomic, strong)UIView* progressBG;
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
    self.progressBG = [[UIView alloc] initWithFrame:CGRectMake(65, 30, viewParent.width - 65 * 2, 8)];
    [self.progressBG setBackgroundColor:[UIColor colorWithHexString:@"fc6e82"]];
    [viewParent addSubview:self.progressBG];
    
    self.progressView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, self.progressBG.height)];
    [self.progressView setBackgroundColor:kCommonTeacherTintColor];
    [self.progressBG addSubview:self.progressView];
    
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
    
    self.attendanceNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, 75, viewParent.width - 65, 20)];
    [self.attendanceNumLabel setFont:[UIFont systemFontOfSize:14]];
    [self.attendanceNumLabel setTextColor:kCommonTeacherTintColor];
    [viewParent addSubview:self.attendanceNumLabel];
    
    UILabel* offNumHintLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, attendanceHintLabel.bottom + 5, 50, 20)];
    [offNumHintLabel setText:@"缺勤:"];
    [offNumHintLabel setFont:[UIFont systemFontOfSize:14]];
    [offNumHintLabel setTextColor:[UIColor colorWithHexString:@"333333"]];
    [viewParent addSubview:offNumHintLabel];
    
    self.offNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, offNumHintLabel.top, viewParent.width - 65, 20)];
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
    if([_model.all.attendance_rate length] > 0){
        [attendancePercentStr appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%%", _model.all.attendance_rate] attributes:@{NSForegroundColorAttributeName : kCommonTeacherTintColor}]];
    }
    [attendancePercentStr setLineSpacing:3];
    [self.attendancePercentLabel setAttributedText:attendancePercentStr];
    
    NSMutableAttributedString* offPercentStr = [[NSMutableAttributedString alloc] initWithString:@"缺勤率\n" attributes:@{NSForegroundColorAttributeName : kColor_33}];
    if([_model.all.absence_rate length] > 0){
        [offPercentStr appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%%", _model.all.absence_rate] attributes:@{NSForegroundColorAttributeName : kRedColor}]];
    }
    [offPercentStr setAlignment:NSTextAlignmentRight];
    [offPercentStr setLineSpacing:3];
    [self.offPercentLabel setAttributedText:offPercentStr];
    
    [self.progressView setWidth:self.progressBG.width * [_model.all.attendance_rate floatValue] / 100];
    
    [self.classNumLabel setText:[NSString stringWithFormat:@"%zd个", _model.all.class_total]];
    [self.totalNumLabel setText:[NSString stringWithFormat:@"%zd人", _model.all.total]];
    NSMutableAttributedString* attendanceStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%zd人", _model.all.attendance] attributes:@{NSForegroundColorAttributeName : kCommonTeacherTintColor}];
    if([_model lateNum] > 0){
        [attendanceStr appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" (其中有%zd人迟到)", [_model lateNum]] attributes:@{NSForegroundColorAttributeName : kCommonTeacherTintColor}]];
    }
    [self.attendanceNumLabel setAttributedText:attendanceStr];
    
    NSMutableAttributedString* absenceStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%zd人",_model.all.absence] attributes:@{NSForegroundColorAttributeName : kRedColor}];
    if([_model absenceWithoutReasonNum] > 0){
        [absenceStr appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" (其中有%zd人无故缺勤)", [_model absenceWithoutReasonNum]] attributes:@{NSForegroundColorAttributeName : kRedColor}]];
    }
    [self.offNumLabel setAttributedText:absenceStr];
    [self.uncommitLabel setText:[NSString stringWithFormat:@"目前未提交考勤的班级还有%zd个班", _model.all.no_submit]];
}

@end
