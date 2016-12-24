//
//  StudentsAttendanceHeaderView.m
//  LianZhiTeacher
//
//  Created by jslsxu on 16/12/22.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "StudentsAttendanceHeaderView.h"

@implementation StudentsAttendanceHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self setBackgroundColor:[UIColor whiteColor]];
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, 30)];
        [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [self.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [self.titleLabel setText:@"当日出勤率:82%"];
        [self.titleLabel setTextColor:kColor_33];
        [self addSubview:self.titleLabel];
        
        self.nameButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.nameButton setFrame:CGRectMake(0, self.titleLabel.bottom, self.width / 2, 40)];
        [self.nameButton setBackgroundColor:[UIColor colorWithHexString:@"1AC082"]];
        [self.nameButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.nameButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [self.nameButton setTitle:@"姓名(50)" forState:UIControlStateNormal];
        [self addSubview:self.nameButton];
        
        self.attendanceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.attendanceButton setFrame:CGRectMake(self.nameButton.right, self.titleLabel.bottom, self.width / 4, 40)];
        [self.attendanceButton setBackgroundColor:kCommonTeacherTintColor];
        [self.attendanceButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
         [self.attendanceButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [self.attendanceButton setTitle:@"出勤(50)" forState:UIControlStateNormal];
        [self.attendanceButton addTarget:self action:@selector(onAttendanceButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.attendanceButton];
        
        self.offButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.offButton setFrame:CGRectMake(self.attendanceButton.right, self.titleLabel.bottom, self.width / 4, 40)];
        [self.offButton setBackgroundColor:kRedColor];
        [self.offButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.offButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [self.offButton setTitle:@"缺勤(50)" forState:UIControlStateNormal];
        [self.offButton addTarget:self action:@selector(onOffButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.offButton];
    }
    return self;
}

- (void)onAttendanceButtonClicked{
    if(self.attendanceClickCallback){
        self.attendanceClickCallback();
    }
}

- (void)onOffButtonClicked{
    if(self.offClickCallback){
        self.offClickCallback();
    }
}

@end
