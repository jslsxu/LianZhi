//
//  StudentAttendanceHeaderView.m
//  LianZhiTeacher
//
//  Created by jslsxu on 16/12/21.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "StudentAttendanceHeaderView.h"

@interface StudentAttendanceHeaderView ()
@property (nonatomic, strong)UIView* contentView;
@property (nonatomic, strong)AvatarView* avatarView;
@property (nonatomic, strong)UILabel* progressHintLabel;
@property (nonatomic, strong)UIView* progressBG;
@property (nonatomic, strong)UIView* progressView;
@property (nonatomic, strong)UILabel* attendancePercentLabel;
@property (nonatomic, strong)UILabel* offPercentLabel;
@property (nonatomic, strong)UILabel* attendanceNumLabel;
@end

@implementation StudentAttendanceHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self setHeight:110];
        self.contentView = [[UIView alloc] initWithFrame:CGRectInset(self.bounds, 10, 10)];
        [self.contentView.layer setCornerRadius:6];
        [self.contentView.layer setMasksToBounds:YES];
        [self.contentView setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:self.contentView];
        
        self.avatarView = [[AvatarView alloc] initWithRadius:18];
        [self.avatarView setOrigin:CGPointMake(10, 15)];
        [self.contentView addSubview:self.avatarView];
        
        self.attendancePercentLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, 50, 40)];
        [self.attendancePercentLabel setFont:[UIFont systemFontOfSize:14]];
        [self.attendancePercentLabel setNumberOfLines:0];
        [self.attendancePercentLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [self.contentView addSubview:self.attendancePercentLabel];
        
        self.offPercentLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.contentView.width - 60, 10, 50, 40)];
        [self.offPercentLabel setFont:[UIFont systemFontOfSize:14]];
        [self.offPercentLabel setNumberOfLines:0];
        [self.offPercentLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [self.contentView addSubview:self.offPercentLabel];
        
        self.progressBG = [[UIView alloc] initWithFrame:CGRectMake(self.attendancePercentLabel.right, 35, self.offPercentLabel.left - self.attendancePercentLabel.right, 8)];
        [self.progressBG setBackgroundColor:[UIColor colorWithHexString:@"fc6e82"]];
        [self.contentView addSubview:self.progressBG];
        
        self.progressView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, self.progressBG.height)];
        [self.progressView setBackgroundColor:kCommonTeacherTintColor];
        [self.progressBG addSubview:self.progressView];
        
        self.progressHintLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.progressHintLabel setText:@"月考勤记录"];
        [self.progressHintLabel setFont:[UIFont systemFontOfSize:14]];
        [self.progressHintLabel setTextColor:kColor_33];
        [self.progressHintLabel sizeToFit];
        [self.progressHintLabel setCenter:CGPointMake(self.progressBG.centerX, 20)];
        [self.contentView addSubview:self.progressHintLabel];
        
        self.attendanceNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.attendancePercentLabel.left, self.contentView.height - 15 - 15, self.contentView.width - 10 - self.attendancePercentLabel.left, 15)];
        [self.attendanceNumLabel setFont:[UIFont systemFontOfSize:14]];
        [self.contentView addSubview:self.attendanceNumLabel];
    }
    return self;
}

- (void)setDate:(NSDate *)date{
    _date = date;
    [self.progressHintLabel setText:[NSString stringWithFormat:@"%zd月考勤记录",[_date month]]];
    [self.progressHintLabel sizeToFit];
    [self.progressHintLabel setCenter:CGPointMake(self.progressBG.centerX, 20)];
}

- (void)setInfo:(StudentAttendanceDetailInfo *)info{
    _info = info;
    NSMutableAttributedString* attendancePercentStr = [[NSMutableAttributedString alloc] initWithString:@"出勤率\n" attributes:@{NSForegroundColorAttributeName : kColor_33}];
    [attendancePercentStr appendAttributedString:[[NSAttributedString alloc] initWithString:[_info.attendance_rate length] > 0 ? [NSString stringWithFormat:@"%@%%", _info.attendance_rate]: @"--" attributes:@{NSForegroundColorAttributeName : kCommonTeacherTintColor}]];
    [attendancePercentStr setLineSpacing:3];
    [attendancePercentStr setAlignment:NSTextAlignmentLeft];
    [self.attendancePercentLabel setAttributedText:attendancePercentStr];
    
    NSMutableAttributedString* offPercentStr = [[NSMutableAttributedString alloc] initWithString:@"缺勤率\n" attributes:@{NSForegroundColorAttributeName : kColor_33}];
    [offPercentStr appendAttributedString:[[NSAttributedString alloc] initWithString:[_info.absence_rate length] > 0 ? [NSString stringWithFormat:@"%@%%", _info.absence_rate]: @"--" attributes:@{NSForegroundColorAttributeName : kRedColor}]];
    [offPercentStr setLineSpacing:3];
    [offPercentStr setAlignment:NSTextAlignmentRight];
    [self.offPercentLabel setAttributedText:offPercentStr];
    
    NSMutableAttributedString* attendanceString = [[NSMutableAttributedString alloc] initWithString:@"出勤:" attributes:@{NSForegroundColorAttributeName : kColor_33}];
    [attendanceString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%zd天\t\t", _info.attendance] attributes:@{NSForegroundColorAttributeName : kCommonTeacherTintColor}]];
    [attendanceString appendAttributedString:[[NSAttributedString alloc] initWithString:@"缺勤:" attributes:@{NSForegroundColorAttributeName : kColor_33}]];
    [attendanceString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%zd天", _info.absence] attributes:@{NSForegroundColorAttributeName : kRedColor}]];
    [self.attendanceNumLabel setAttributedText:attendanceString];
    
    [self.progressView setWidth:self.progressBG.width * [_info.attendance_rate floatValue] / 100];
    
}

- (void)setStudentInfo:(StudentInfo *)studentInfo{
    _studentInfo = studentInfo;
    [self.avatarView sd_setImageWithURL:[NSURL URLWithString:_studentInfo.avatar] placeholderImage:nil];
}

@end
