//
//  VacationHistoryModel.h
//  LianZhiParent
//
//  Created by jslsxu on 15/5/27.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "TNListModel.h"
typedef NS_ENUM(NSInteger, LeaveType)
{
    LeaveTypeAbsence = 0,               //缺勤
    LeaveTypeLeave,                 //请假
    LeaveTypeNormal,                //出勤
};
@interface VacationHistoryItem : TNModelItem
@property (nonatomic, copy)NSString *vacationID;
@property (nonatomic, copy)NSString *ctime;
@property (nonatomic, copy)NSString *remark;
@property (nonatomic, copy)NSString *leaveDate;
@property (nonatomic, copy)NSString *leaveTime;
@property (nonatomic, copy)NSString *arriveTime;
@property (nonatomic, assign)LeaveType leaveType;
@end

@interface VacationHistoryModel : TNListModel

@end
