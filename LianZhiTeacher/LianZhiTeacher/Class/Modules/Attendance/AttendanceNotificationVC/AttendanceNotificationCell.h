//
//  AttendanceNotificationCell.h
//  LianZhiTeacher
//
//  Created by jslsxu on 16/12/18.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "TNTableViewCell.h"

@interface AttendanceNotificationCell : TNTableViewCell
{
    UIView*                 _bgView;
    AvatarView*             _avatarView;
    UIButton*               _deleteButton;
    UILabel*                _nameLabel;
    UILabel*                _timeLabel;
    UILabel*                _contentLabel;
    UIView*                 _extraView;
    UIView*                 _sepLine;
    UILabel*                _attendanceTimeLabel;
}
@property (nonatomic, copy)void (^deleteCallback)();
@end
