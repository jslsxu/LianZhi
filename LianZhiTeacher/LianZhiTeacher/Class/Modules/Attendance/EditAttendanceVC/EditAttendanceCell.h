//
//  EditAttendanceCell.h
//  LianZhiTeacher
//
//  Created by jslsxu on 16/12/23.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "TNTableViewCell.h"
#import "StudentsAttendanceListModel.h"
@interface EditAttendanceCell : TNTableViewCell
@property (nonatomic, copy)void (^attendanceChanged)();
- (void)flash;
@end
