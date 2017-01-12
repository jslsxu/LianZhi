//
//  ClassAttendanceCell.m
//  LianZhiTeacher
//
//  Created by jslsxu on 16/12/18.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "ClassAttendanceCell.h"
#import "ClassAttendanceListModel.h"
@interface ClassAttendanceCell ()
@property (nonatomic, strong)UIView* bgView;
@property (nonatomic, strong)LogoView* logoView;
@property (nonatomic, strong)UILabel* classLabel;
@property (nonatomic, strong)UILabel* attendanceLabel;
@property (nonatomic, strong)UILabel* teacherLabel;
@property (nonatomic, strong)UIButton* chatButton;
@property (nonatomic, strong)UIButton* mobileButton;
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
        
        self.logoView = [[LogoView alloc] initWithRadius:24];
        [self.logoView setOrigin:CGPointMake(10, (self.bgView.height - self.logoView.height) / 2)];
        [self.bgView addSubview:self.logoView];
        
        self.classLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.classLabel setFont:[UIFont systemFontOfSize:15]];
        [self.bgView addSubview:self.classLabel];
        
        self.attendanceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.attendanceLabel setFont:[UIFont systemFontOfSize:13]];
        [self.bgView addSubview:self.attendanceLabel];
        
        self.teacherLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.teacherLabel setFont:[UIFont systemFontOfSize:14]];
        [self.bgView addSubview:self.teacherLabel];
        
        self.mobileButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.mobileButton setImage:[UIImage imageNamed:@"AttendanceMobile"] forState:UIControlStateNormal];
        [self.mobileButton addTarget:self action:@selector(onMobileClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.bgView addSubview:self.mobileButton];
        
        self.chatButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.chatButton setImage:[UIImage imageNamed:@"AttendanceChat"] forState:UIControlStateNormal];
        [self.chatButton addTarget:self action:@selector(onChatClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.bgView addSubview:self.chatButton];
    }
    return self;
}

- (void)onReloadData:(TNModelItem *)modelItem{
    ClassAttendanceItem* attendanceItem = (ClassAttendanceItem *)modelItem;
    [self.logoView sd_setImageWithURL:[NSURL URLWithString:attendanceItem.class_info.logo] placeholderImage:nil];
    [self.classLabel setWidth:0];
    NSMutableAttributedString* classString = nil;
    if([attendanceItem.class_info.name length] > 0){
        classString = [[NSMutableAttributedString alloc] initWithString:attendanceItem.class_info.name attributes:@{NSForegroundColorAttributeName : kCommonTeacherTintColor}];
        [classString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"  %zd人", attendanceItem.total] attributes:@{NSForegroundColorAttributeName : kColor_99}]];
    }
    [self.classLabel setAttributedText:classString];
    [self.classLabel sizeToFit];
    [self.classLabel setOrigin:CGPointMake(self.logoView.right + 6, self.logoView.top)];
    
    [self.attendanceLabel setWidth:0];
    NSMutableAttributedString* attendanceString = [[NSMutableAttributedString alloc] initWithString:@"出勤:" attributes:@{NSForegroundColorAttributeName : kColor_99}];
    NSString* attendanceNumString = nil;
    NSString* absenceNumString = nil;
    if(attendanceItem.submit_leave){
        attendanceNumString = [NSString stringWithFormat:@"%zd人\t", attendanceItem.attendance];
        absenceNumString = [NSString stringWithFormat:@"%zd人", attendanceItem.absence];
    }
    else{
        attendanceNumString = @"-人";
        absenceNumString = @"-人";
    }
    [attendanceString appendAttributedString:[[NSAttributedString alloc] initWithString:attendanceNumString attributes:@{NSForegroundColorAttributeName : kCommonTeacherTintColor}]];
    [attendanceString appendAttributedString:[[NSAttributedString alloc] initWithString:@"缺勤:" attributes:@{NSForegroundColorAttributeName : kColor_99}]];
    [attendanceString appendAttributedString:[[NSAttributedString alloc] initWithString:absenceNumString attributes:@{NSForegroundColorAttributeName : kRedColor}]];
    [self.attendanceLabel setAttributedText:attendanceString];
    [self.attendanceLabel sizeToFit];
    [self.attendanceLabel setOrigin:CGPointMake(self.logoView.right + 6, self.logoView.bottom - self.attendanceLabel.height)];
    
    NSMutableAttributedString* teacherString = nil;
    if([attendanceItem.teacherName length] > 0 && [attendanceItem.class_info.course length] > 0){
        teacherString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ ", attendanceItem.teacherName] attributes:@{NSForegroundColorAttributeName : kColor_33}];
        [teacherString appendAttributedString:[[NSAttributedString alloc] initWithString:attendanceItem.class_info.course attributes:@{NSForegroundColorAttributeName : kColor_99}]];

    }
    [self.teacherLabel setAttributedText:teacherString];
    [self.teacherLabel sizeToFit];
    [self.teacherLabel setOrigin:CGPointMake(self.bgView.width - 10 - self.teacherLabel.width, 15)];
//    if(attendanceItem.is_admin && !attendanceItem.submit_leave && [attendanceItem.teacherID length] > 0){
//        [self.mobileButton setHidden:NO];
//        [self.chatButton setHidden:NO];
//    }
//    else{
//        [self.mobileButton setHidden:YES];
//        [self.chatButton setHidden:YES];
//    }
    [self.mobileButton setFrame:CGRectMake(self.bgView.width - 10 - 25, self.teacherLabel.bottom + 5, 25, 25)];
    [self.chatButton setFrame:CGRectMake(self.mobileButton.left - 25, self.mobileButton.y, 25, 25)];
}

- (void)onMobileClicked{
    
}

- (void)onChatClicked{
    
}

+ (NSNumber *)cellHeight:(TNModelItem *)modelItem cellWidth:(NSInteger)width{
    return @(85);
}

@end
