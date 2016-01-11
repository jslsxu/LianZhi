//
//  MyAttendanceItem.m
//  LianZhiTeacher
//
//  Created by jslsxu on 15/10/7.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "MyAttendanceItem.h"

@implementation MyAttendanceItem

- (void)parseData:(TNDataWrapper *)dataWrapper
{
    self.timeStamp = [dataWrapper getIntegerForKey:@"dk_date"];
    TNDataWrapper *startWrapper = [dataWrapper getDataWrapperForKey:@"start"];
    self.startTime = [startWrapper getStringForKey:@"time_hi"];
    self.startRegion = [startWrapper getStringForKey:@"time_region"];
    TNDataWrapper *endWrapper = [dataWrapper getDataWrapperForKey:@"end"];
    self.endTime = [endWrapper getStringForKey:@"time_hi"];
    self.endRegion = [endWrapper getStringForKey:@"time_region"];
}
@end
