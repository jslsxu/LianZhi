//
//  StudentAttendanceCell.h
//  LianZhiTeacher
//
//  Created by jslsxu on 15/10/8.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StudentAttendanceCell : UICollectionViewCell
{
    AvatarView*     _avatarView;
    UILabel*        _statusLabel;
    UILabel*        _nameLabel;
}
@property (nonatomic, strong)StudentInfo *studentInfo;
@end
