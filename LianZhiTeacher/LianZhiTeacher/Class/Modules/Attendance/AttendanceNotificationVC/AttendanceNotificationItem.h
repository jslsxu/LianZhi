//
//  AttendanceNotificationItem.h
//  LianZhiTeacher
//
//  Created by jslsxu on 17/1/12.
//  Copyright © 2017年 jslsxu. All rights reserved.
//

#import "TNModelItem.h"

@interface AttendanceNotificationContent : TNBaseObject
@property (nonatomic, strong)ClassInfo* class_info;
@property (nonatomic, strong)StudentInfo* child_info;
@property (nonatomic, copy)NSString* index_words;
@property (nonatomic, copy)NSString* notice_words;
@property (nonatomic, copy)NSString* from_date;
@property (nonatomic, copy)NSString* to_date;
@end

@interface AttendanceNotificationItem : TNModelItem
@property (nonatomic, copy)NSString* msgID;
@property (nonatomic, copy)NSString* from_uid;
@property (nonatomic, copy)NSString* time;
@property (nonatomic, assign)BOOL is_new;
@property (nonatomic, strong)AttendanceNotificationContent* words;
@end
