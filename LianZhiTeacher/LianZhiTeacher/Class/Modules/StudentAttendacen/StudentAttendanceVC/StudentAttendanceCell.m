//
//  StudentAttendanceCell.m
//  LianZhiTeacher
//
//  Created by jslsxu on 15/10/8.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "StudentAttendanceCell.h"

@implementation StudentAttendanceCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        _avatarView = [[AvatarView alloc] initWithFrame:CGRectMake((self.width - 40) / 2, (self.height - 60) / 2, 40, 40)];
        [_avatarView.layer setCornerRadius:20];
        [_avatarView.layer setMasksToBounds:YES];
        [self addSubview:_avatarView];
        
        _statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _avatarView.height - 13, _avatarView.width, 13)];
        [_statusLabel setTextColor:[UIColor whiteColor]];
        [_statusLabel setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.7]];
        [_statusLabel setFont:[UIFont systemFontOfSize:9]];
        [_statusLabel setTextAlignment:NSTextAlignmentCenter];
        [_avatarView addSubview:_statusLabel];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _avatarView.bottom, self.width, 20)];
        [_nameLabel setFont:[UIFont systemFontOfSize:12]];
        [_nameLabel setTextColor:[UIColor colorWithHexString:@"2c2c2c"]];
        [_nameLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:_nameLabel];
        
        UIView *hLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - kLineHeight, self.width, kLineHeight)];
        [hLine setBackgroundColor:[UIColor colorWithHexString:@"D8D8D8"]];
        [self addSubview:hLine];
        
        UIView *vLine = [[UIView alloc] initWithFrame:CGRectMake(self.width - kLineHeight, 0, kLineHeight, self.height)];
        [vLine setBackgroundColor:[UIColor colorWithHexString:@"D8D8D8"]];
        [self addSubview:vLine];
    }
    return self;
}

- (void)setStudentInfo:(StudentInfo *)studentInfo
{
    _studentInfo = studentInfo;
    [_avatarView setImageWithUrl:[NSURL URLWithString:[UserCenter sharedInstance].userInfo.avatar]];
}

@end
