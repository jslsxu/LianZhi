//
//  AttendanceNotificationItem.m
//  LianZhiTeacher
//
//  Created by jslsxu on 17/1/12.
//  Copyright © 2017年 jslsxu. All rights reserved.
//

#import "AttendanceNotificationItem.h"

@implementation AttendanceNotificationContent

@end

@implementation AttendanceNotificationItem
+ (NSDictionary<NSString*, id> *)modelCustomPropertyMapper{
    return @{ @"msgID" : @"id"};
}

@end
