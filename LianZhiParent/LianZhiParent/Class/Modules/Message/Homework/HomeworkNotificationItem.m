//
//  HomeworkNotificationItem.m
//  LianZhiParent
//
//  Created by qingxu zhou on 16/10/24.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "HomeworkNotificationItem.h"

@implementation HomeworkNotificationItem
+ (NSDictionary<NSString*, id> *)modelCustomPropertyMapper{
    return @{@"msgId" : @"id",
             @"etype" : @"exercises.etype",
             @"course_name" : @"exercises.course_name",
             @"reply_close_ctime" : @"exercises.reply_close_ctime",
             @"hasVoice" : @"exercises.voice",
             @"hasPhoto" : @"exercises.pics",
             @"teacher" : @"exercises.teacher",
             @"status" : @"exercises.status",
             @"eid" : @"exercises.eid"
             };
}
@end
