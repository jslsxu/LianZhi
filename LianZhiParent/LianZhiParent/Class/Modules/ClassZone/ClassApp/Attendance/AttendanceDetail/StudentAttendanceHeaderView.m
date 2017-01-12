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
        [self.offPercentLabel setTextAlignment:NSTextAlignmentRight];
        [self.contentView addSubview:self.offPercentLabel];
        
        UIView* progressBG = [[UIView alloc] initWithFrame:CGRectMake(self.attendancePercentLabel.right, 35, self.offPercentLabel.left - self.attendancePercentLabel.right, 10)];
        [progressBG setBackgroundColor:[UIColor colorWithHexString:@"fc6e82"]];
        [self.contentView addSubview:progressBG];
        
        self.progressView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, progressBG.height)];
        [self.progressView setBackgroundColor:kCommonParentTintColor];
        [progressBG addSubview:self.progressView];
        
        UILabel* progressHintLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [progressHintLabel setText:@"月考勤记录"];
        [progressHintLabel setFont:[UIFont systemFontOfSize:14]];
        [progressHintLabel setTextColor:kColor_33];
        [progressHintLabel sizeToFit];
        [progressHintLabel setCenter:CGPointMake(progressBG.centerX, 20)];
        [self.contentView addSubview:progressHintLabel];
        
        self.attendanceNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.attendancePercentLabel.left, self.contentView.height - 15 - 15, self.contentView.width - 10 - self.attendancePercentLabel.left, 15)];
        [self.attendanceNumLabel setFont:[UIFont systemFontOfSize:14]];
        [self.contentView addSubview:self.attendanceNumLabel];
    }
    return self;
}

- (void)setInfo:(AttendanceInfo *)info{
    _info = info;
    NSMutableAttributedString* attendancePercentStr = [[NSMutableAttributedString alloc] initWithString:@"出勤率\n" attributes:@{NSForegroundColorAttributeName : kColor_33}];
    [attendancePercentStr appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%%", _info.attendance_rate] attributes:@{NSForegroundColorAttributeName : kCommonParentTintColor}]];
    [self.attendancePercentLabel setAttributedText:attendancePercentStr];
    
    NSMutableAttributedString* offPercentStr = [[NSMutableAttributedString alloc] initWithString:@"缺勤率\n" attributes:@{NSForegroundColorAttributeName : kColor_33}];
    [offPercentStr appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%%", _info.absence_rate] attributes:@{NSForegroundColorAttributeName : kRedColor}]];
    [self.offPercentLabel setAttributedText:offPercentStr];
    
    NSMutableAttributedString* attendanceString = [[NSMutableAttributedString alloc] initWithString:@"出勤:" attributes:@{NSForegroundColorAttributeName : kColor_33}];
    [attendanceString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%zd天\t\t", _info.attendance] attributes:@{NSForegroundColorAttributeName : kCommonParentTintColor}]];
    [attendanceString appendAttributedString:[[NSAttributedString alloc] initWithString:@"缺勤:" attributes:@{NSForegroundColorAttributeName : kColor_33}]];
    [attendanceString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%zd天", _info.absence] attributes:@{NSForegroundColorAttributeName : kRedColor}]];
    [self.attendanceNumLabel setAttributedText:attendanceString];
}


@end
