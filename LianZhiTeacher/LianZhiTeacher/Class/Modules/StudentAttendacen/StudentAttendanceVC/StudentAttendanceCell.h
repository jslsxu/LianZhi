//
//  StudentAttendanceCell.h
//  LianZhiTeacher
//
//  Created by jslsxu on 15/10/8.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StudentAttendanceModel.h"

extern NSString *const kStudentAttendanceStatusChanged;

@interface StudentAttendanceCell : TNTableViewCell
{
    NSMutableArray*    _statusArray;
    UILabel*    _nameLabel;
    UIView*     _sepLine;
}

@end
