//
//  StudentAttendanceModel.m
//  LianZhiTeacher
//
//  Created by jslsxu on 16/1/5.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "StudentAttendanceModel.h"

@implementation StudentAttendanceItem

- (void)parseData:(TNDataWrapper *)dataWrapper
{
    self.studentID = [dataWrapper getStringForKey:@"id"];
    self.studentName = [dataWrapper getStringForKey:@"name"];
    self.vacationID = [dataWrapper getStringForKey:@"id"];
    self.ctime = [dataWrapper getStringForKey:@"ctime"];
    NSString *leaveDate = [dataWrapper getStringForKey:@"leave_date"];
    if(leaveDate.length > 10)
        self.leaveDate = [leaveDate substringToIndex:10];
    self.leaveTime = [dataWrapper getStringForKey:@"leave_time"];
    self.arriveTime = [dataWrapper getStringForKey:@"arrive_time"];
    self.leaveType = [dataWrapper getIntegerForKey:@"status"];
    self.remark = [dataWrapper getStringForKey:@"words"];
    self.reason = [dataWrapper getStringForKey:@"reason"];
}

@end

@implementation StudentAttendanceModel

- (BOOL)parseData:(TNDataWrapper *)data type:(REQUEST_TYPE)type
{
    if(type == REQUEST_REFRESH)
        [self.modelItemArray removeAllObjects];
    TNDataWrapper *leaveTotalWrapper = [data getDataWrapperForKey:@"leaveTotal"];
    self.absenceNum = [leaveTotalWrapper getIntegerForIndex:0];
    self.leaveNum = [leaveTotalWrapper getIntegerForIndex:1];
    self.normalNum = [leaveTotalWrapper getIntegerForIndex:2];
    TNDataWrapper *studentWrapper = [data getDataWrapperForKey:@"students"];
    if(studentWrapper.count > 0)
    {
        for (NSInteger i = 0; i < studentWrapper.count; i++)
        {
            TNDataWrapper *studetnItemWrapper = [studentWrapper getDataWrapperForIndex:i];
            StudentAttendanceItem *item = [[StudentAttendanceItem alloc] init];
            [item parseData:studetnItemWrapper];
            [self.modelItemArray addObject:item];
        }
    }
    [self sort];
    return YES;
}

- (void)sort
{
    [self.modelItemArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        StudentAttendanceItem *item1 = (StudentAttendanceItem *)obj1;
        StudentAttendanceItem *item2 = (StudentAttendanceItem *)obj2;
        NSComparisonResult result = NSOrderedSame;
        if(item1.leaveType == 3 - self.sortColumn && item2.leaveType != 3 - self.sortColumn)
            result = NSOrderedAscending;
        else if(item1.leaveType != 3 - self.sortColumn && item2.leaveType != 3 - self.sortColumn)
            result = NSOrderedSame;
        else
            result = NSOrderedDescending;
        return result;
    }];
}
@end
