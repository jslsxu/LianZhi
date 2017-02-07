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
@property (nonatomic, strong)YYLabel* attendanceLabel;
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
        self.bgView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, self.width - 10 * 2, 90 - 10)];
        [self.bgView setBackgroundColor:[UIColor whiteColor]];
        [self.bgView.layer setCornerRadius:6];
        [self.bgView.layer setMasksToBounds:YES];
        [self addSubview:self.bgView];
        
        self.logoView = [[LogoView alloc] initWithRadius:25];
        [self.logoView setOrigin:CGPointMake(10, 15)];
        [self.bgView addSubview:self.logoView];
        
        self.classLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.classLabel setFont:[UIFont systemFontOfSize:16]];
        [self.bgView addSubview:self.classLabel];
        
        self.attendanceLabel = [[YYLabel alloc] initWithFrame:CGRectZero];
        [self.attendanceLabel setFont:[UIFont systemFontOfSize:13]];
        [self.attendanceLabel setNumberOfLines:0];
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
        attendanceNumString = [NSString stringWithFormat:@"%zd人    ", attendanceItem.attendance];
        absenceNumString = [NSString stringWithFormat:@"%zd人    ", attendanceItem.absence];
    }
    else{
        attendanceNumString = @"-人";
        absenceNumString = @"-人";
    }
    [attendanceString appendAttributedString:[[NSAttributedString alloc] initWithString:attendanceNumString attributes:@{NSForegroundColorAttributeName : kCommonTeacherTintColor}]];
    [attendanceString appendAttributedString:[[NSAttributedString alloc] initWithString:@"缺勤:" attributes:@{NSForegroundColorAttributeName : kColor_99}]];
    [attendanceString appendAttributedString:[[NSAttributedString alloc] initWithString:absenceNumString attributes:@{NSForegroundColorAttributeName : kRedColor}]];
    
    if(attendanceItem.late_num + attendanceItem.noleave_num > 0){
        [attendanceString appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n其中:" attributes:@{NSForegroundColorAttributeName : kColor_99}]];
        if(attendanceItem.late_num > 0){
            NSString* formatStr = attendanceItem.noleave_num > 0 ? @"%zd人迟到，" : @"%zd人迟到";
            [attendanceString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:formatStr,attendanceItem.late_num] attributes:@{NSForegroundColorAttributeName : kCommonTeacherTintColor}]];
        }
        if(attendanceItem.noleave_num > 0){
            [attendanceString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%zd人无故缺勤", attendanceItem.noleave_num] attributes:@{NSForegroundColorAttributeName : kRedColor}]];
        }
    }
    [attendanceString setLineSpacing:2];
    [self.attendanceLabel setAttributedText:attendanceString];
    [self.attendanceLabel sizeToFit];
    [self.attendanceLabel setOrigin:CGPointMake(self.logoView.right + 6, self.classLabel.bottom + 5)];
    NSString* name = attendanceItem.teacherName;
    if([name isEqualToString:[UserCenter sharedInstance].userInfo.name]){
        name = @"我";
    }
    NSMutableAttributedString* teacherString = nil;
    if([name length] > 0 && [attendanceItem.class_info.course length] > 0){
        teacherString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ ", name] attributes:@{NSForegroundColorAttributeName : kColor_33}];
        [teacherString appendAttributedString:[[NSAttributedString alloc] initWithString:attendanceItem.class_info.course attributes:@{NSForegroundColorAttributeName : kColor_99}]];

    }
    [self.teacherLabel setAttributedText:teacherString];
    [self.teacherLabel sizeToFit];
    [self.teacherLabel setOrigin:CGPointMake(self.bgView.width - 10 - self.teacherLabel.width, 15)];
    if(attendanceItem.is_admin && !attendanceItem.submit_leave && [attendanceItem.teacherID length] > 0){
        [self.mobileButton setHidden:NO];
        [self.chatButton setHidden:NO];
    }
    else{
        [self.mobileButton setHidden:YES];
        [self.chatButton setHidden:YES];
    }
    [self.mobileButton setFrame:CGRectMake(self.bgView.width - 10 - 25, self.teacherLabel.bottom + 5, 25, 25)];
    [self.chatButton setFrame:CGRectMake(self.mobileButton.left - 25, self.mobileButton.y, 25, 25)];
}

- (void)onMobileClicked{
    ClassAttendanceItem* attendanceItem = (ClassAttendanceItem *)self.modelItem;
    NSString* mobile = attendanceItem.mobile;
    LGAlertView *alertView = [[LGAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"确定拨打电话%@吗", mobile] style:LGAlertViewStyleAlert buttonTitles:@[@"取消", @"拨打电话"] cancelButtonTitle:nil destructiveButtonTitle:nil];
    [alertView setCancelButtonFont:[UIFont systemFontOfSize:18]];
    [alertView setButtonsBackgroundColorHighlighted:[UIColor colorWithHexString:@"dddddd"]];
    [alertView setActionHandler:^(LGAlertView *alertView, NSString *title, NSUInteger index) {
        if(index == 1){
            NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel://%@", mobile];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }
    }];
    [alertView showAnimated:YES completionHandler:nil];
}

- (void)onChatClicked{
    ClassAttendanceItem* attendanceItem = (ClassAttendanceItem *)self.modelItem;
    JSMessagesViewController *chatVC = [[JSMessagesViewController alloc] init];
    [chatVC setTo_objid:[UserCenter sharedInstance].curSchool.schoolID];
    [chatVC setTargetID:attendanceItem.teacherID];
    [chatVC setChatType:ChatTypeTeacher];
    [chatVC setMobile:attendanceItem.mobile];
    [chatVC setName:attendanceItem.teacherName];
    [ApplicationDelegate popAndPush:chatVC];
}

+ (NSNumber *)cellHeight:(TNModelItem *)modelItem cellWidth:(NSInteger)width{
    return @(90);
}

@end
