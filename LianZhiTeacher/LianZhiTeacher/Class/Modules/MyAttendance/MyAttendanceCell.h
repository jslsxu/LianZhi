//
//  MyAttendanceCell.h
//  LianZhiTeacher
//
//  Created by jslsxu on 15/10/7.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "TNTableViewCell.h"

@interface MyAttendanceCell : TNTableViewCell
{
    UIView*     _verLine;
    UILabel*    _dateLabel;
    UILabel*    _startlabel;
    UILabel*    _endLabel;
}
@property (nonatomic, assign)BOOL isDark;
@end
