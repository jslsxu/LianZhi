//
//  StudentAttendanceVC.h
//  LianZhiTeacher
//
//  Created by jslsxu on 15/10/7.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"
#import "StudentAttendanceCell.h"
#import "StudentAttendanceHeaderView.h"
#import "DatePickerView.h"

@interface StudentAttendanceHeader : UITableViewHeaderFooterView
{
    UILabel*    _nameLabel;
    UILabel*    _attendanceLabel;
    UILabel*    _vacationLabel;
    UILabel*    _leftLabel;
}
@end

@interface StudentAttendanceVC : TNBaseTableViewController
{
    DatePickerView* _datePickerView;
}
@property (nonatomic, strong)ClassInfo *classInfo;
@end
