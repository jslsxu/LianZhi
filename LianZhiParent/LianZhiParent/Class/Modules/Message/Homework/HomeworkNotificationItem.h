//
//  HomeworkNotificationItem.h
//  LianZhiParent
//
//  Created by qingxu zhou on 16/10/24.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "TNBaseObject.h"

typedef NS_ENUM(NSInteger, HomeworkStatus){
    HomeworkStatusUnread = 7,        //未读
    HomeworkStatusRead = 4,                     //已读
    HomeworkStatusWaitMark = 10,             //等待批阅
    HomeworkStatusMarked = 1,               //已批阅
};

@interface HomeworkNotificationItem : TNBaseObject
@property (nonatomic, copy)NSString* msgId;
@property (nonatomic, copy)NSString*    eid;
@property (nonatomic, strong)UserInfo*  teacher;
@property (nonatomic, copy)NSString *words;
@property (nonatomic, copy)NSString*    course_name;
@property (nonatomic, assign)HomeworkStatus status;
@property (nonatomic, copy)NSString*    time;
@property (nonatomic, assign)BOOL reply_close;
@property (nonatomic, copy)NSString* reply_close_ctime;
@property (nonatomic, assign)BOOL   etype;
@property (nonatomic, assign)BOOL hasPhoto;
@property (nonatomic, assign)BOOL hasVoice;
@property (nonatomic, assign)BOOL is_new;
@end
