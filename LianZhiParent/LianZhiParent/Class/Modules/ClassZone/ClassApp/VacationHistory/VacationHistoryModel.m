//
//  VacationHistoryModel.m
//  LianZhiParent
//
//  Created by jslsxu on 15/5/27.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "VacationHistoryModel.h"

@implementation VacationHistoryItem

- (void)parseData:(TNDataWrapper *)dataWrapper
{
    self.vacationID = [dataWrapper getStringForKey:@"id"];
    self.ctime = [dataWrapper getStringForKey:@"ctime"];
    self.leaveDate = [[dataWrapper getStringForKey:@"leave_date"] substringToIndex:10];
    self.leaveTime = [dataWrapper getStringForKey:@"leave_time"];
    self.arriveTime = [dataWrapper getStringForKey:@"arrive_time"];
    self.leaveType = [dataWrapper getIntegerForKey:@"status"];
    self.remark = [dataWrapper getStringForKey:@"words"];
}
@end

@implementation VacationHistoryModel

@end
