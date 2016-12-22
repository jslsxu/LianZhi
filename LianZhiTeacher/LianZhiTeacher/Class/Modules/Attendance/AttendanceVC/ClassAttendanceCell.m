//
//  ClassAttendanceCell.m
//  LianZhiTeacher
//
//  Created by jslsxu on 16/12/18.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "ClassAttendanceCell.h"

@interface ClassAttendanceCell ()
@property (nonatomic, strong)UIView* bgView;
@property (nonatomic, strong)AvatarView* avatar;
@property (nonatomic, strong)UILabel* classLabel;
@property (nonatomic, strong)UILabel* attendanceLabel;
@property (nonatomic, strong)UILabel* teacherLabel;
@end

@implementation ClassAttendanceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self setBackgroundColor:[UIColor clearColor]];
        self.bgView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, self.width - 10 * 2, 85 - 10)];
        [self.bgView setBackgroundColor:[UIColor whiteColor]];
        [self.bgView.layer setCornerRadius:6];
        [self.bgView.layer setMasksToBounds:YES];
        [self addSubview:self.bgView];
        
        self.avatar = [[AvatarView alloc] initWithRadius:24];
        [self.avatar setOrigin:CGPointMake(10, (self.bgView.height - self.avatar.height) / 2)];
        [self.bgView addSubview:self.avatar];
        
        self.classLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.classLabel setFont:[UIFont systemFontOfSize:15]];
        [self.bgView addSubview:self.classLabel];
        
        self.attendanceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.attendanceLabel setFont:[UIFont systemFontOfSize:13]];
        [self.bgView addSubview:self.attendanceLabel];
        
        self.teacherLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.teacherLabel setFont:[UIFont systemFontOfSize:14]];
        [self.bgView addSubview:self.teacherLabel];
    }
    return self;
}

- (void)onReloadData:(TNModelItem *)modelItem{
    [self.classLabel setWidth:0];
    NSMutableAttributedString* classString = [[NSMutableAttributedString alloc] initWithString:@"14级10班" attributes:@{NSForegroundColorAttributeName : kCommonTeacherTintColor}];
    [classString appendAttributedString:[[NSAttributedString alloc] initWithString:@"50人" attributes:@{NSForegroundColorAttributeName : kColor_99}]];
    [self.classLabel setAttributedText:classString];
    [self.classLabel sizeToFit];
    [self.classLabel setOrigin:CGPointMake(self.avatar.right + 6, self.avatar.top)];
    
    [self.attendanceLabel setWidth:0];
    NSMutableAttributedString* attendanceString = [[NSMutableAttributedString alloc] initWithString:@"出勤:" attributes:@{NSForegroundColorAttributeName : kColor_99}];
    [attendanceString appendAttributedString:[[NSAttributedString alloc] initWithString:@"48人\t" attributes:@{NSForegroundColorAttributeName : kCommonTeacherTintColor}]];
    [attendanceString appendAttributedString:[[NSAttributedString alloc] initWithString:@"缺勤:" attributes:@{NSForegroundColorAttributeName : kColor_99}]];
    [attendanceString appendAttributedString:[[NSAttributedString alloc] initWithString:@"2人" attributes:@{NSForegroundColorAttributeName : kRedColor}]];
    [self.attendanceLabel setAttributedText:attendanceString];
    [self.attendanceLabel sizeToFit];
    [self.attendanceLabel setOrigin:CGPointMake(self.avatar.right + 6, self.avatar.bottom - self.attendanceLabel.height)];
    
    NSMutableAttributedString* teacherString = [[NSMutableAttributedString alloc] initWithString:@"李慧敏 " attributes:@{NSForegroundColorAttributeName : kColor_33}];
    [teacherString appendAttributedString:[[NSAttributedString alloc] initWithString:@"班主任" attributes:@{NSForegroundColorAttributeName : kColor_99}]];
    [self.teacherLabel setAttributedText:teacherString];
    [self.teacherLabel sizeToFit];
    [self.teacherLabel setOrigin:CGPointMake(self.bgView.width - 10 - self.teacherLabel.width, 15)];
}

+ (NSNumber *)cellHeight:(TNModelItem *)modelItem cellWidth:(NSInteger)width{
    return @(85);
}

@end
