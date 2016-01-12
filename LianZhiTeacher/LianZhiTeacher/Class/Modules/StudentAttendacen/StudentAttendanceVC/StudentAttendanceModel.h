//
//  StudentAttendanceModel.h
//  LianZhiTeacher
//
//  Created by jslsxu on 16/1/5.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "TNListModel.h"

typedef NS_ENUM(NSInteger, LeaveType)
{
    LeaveTypeAbsence = 0,               //缺勤
    LeaveTypeLeave,                 //请假
    LeaveTypeNormal,                //出勤
};

@interface StudentAttendanceItem : TNModelItem
@property (nonatomic, copy)NSString *studentID;
@property (nonatomic, copy)NSString *studentName;
@property (nonatomic, copy)NSString *vacationID;
@property (nonatomic, copy)NSString *ctime;
@property (nonatomic, copy)NSString *remark;
@property (nonatomic, copy)NSString *leaveDate;
@property (nonatomic, copy)NSString *leaveTime;
@property (nonatomic, copy)NSString *arriveTime;
@property (nonatomic, assign)LeaveType leaveType;
@end

@interface StudentAttendanceModel : TNListModel
@property (nonatomic, assign)NSInteger sortColumn;
@property (nonatomic, assign)NSInteger absenceNum;
@property (nonatomic, assign)NSInteger leaveNum;
@property (nonatomic, assign)NSInteger normalNum;
- (void)sort;
@end
