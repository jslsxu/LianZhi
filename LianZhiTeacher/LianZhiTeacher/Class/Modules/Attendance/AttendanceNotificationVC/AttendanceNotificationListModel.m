//
//  AttendanceNotificationListModel.m
//  LianZhiTeacher
//
//  Created by jslsxu on 17/1/12.
//  Copyright © 2017年 jslsxu. All rights reserved.
//

#import "AttendanceNotificationListModel.h"

@implementation AttendanceNotificationListModel

- (BOOL)hasMoreData{
    return self.has_next;
}

- (NSString *)minID
{
    AttendanceNotificationItem *lastItem = [self.modelItemArray lastObject];
    return lastItem.msgID;
}

- (BOOL)parseData:(TNDataWrapper *)data type:(REQUEST_TYPE)type{
    if(type == REQUEST_REFRESH){
        [self.modelItemArray removeAllObjects];
    }
    
    self.has_next = [data getBoolForKey:@"has_next"];
    TNDataWrapper* listWrapper = [data getDataWrapperForKey:@"list"];
    NSArray* items = [AttendanceNotificationItem nh_modelArrayWithJson:listWrapper.data];
    [self.modelItemArray addObjectsFromArray:items];
    return YES;
}
@end
