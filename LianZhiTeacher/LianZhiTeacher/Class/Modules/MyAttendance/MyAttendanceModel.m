//
//  MyAttendanceModel.m
//  LianZhiTeacher
//
//  Created by jslsxu on 15/10/7.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "MyAttendanceModel.h"

@implementation MyAttendanceModel

- (BOOL)parseData:(TNDataWrapper *)data type:(REQUEST_TYPE)type
{
    if(type == REQUEST_REFRESH)
        [self.modelItemArray removeAllObjects];
    self.todayItem = nil;
    TNDataWrapper *todayWrapper = [data getDataWrapperForKey:@"day"];
    if(todayWrapper.count > 0)
    {
        MyAttendanceItem *todayItem = [[MyAttendanceItem alloc] init];
        [todayItem parseData:todayWrapper];
        self.todayItem = todayItem;
    }
    TNDataWrapper *historyWrapper = [data getDataWrapperForKey:@"history"];
    for (NSInteger i = 0; i < historyWrapper.count; i++)
    {
        TNDataWrapper *historyItemWrapper = [historyWrapper getDataWrapperForIndex:i];
        MyAttendanceItem *item = [[MyAttendanceItem alloc] init];
        [item parseData:historyItemWrapper];
        [self.modelItemArray addObject:item];
    }
    
    return YES;
}
@end
