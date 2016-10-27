//
//  HomeworkNotificationItem.h
//  LianZhiParent
//
//  Created by qingxu zhou on 16/10/24.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "TNBaseObject.h"

typedef NS_ENUM(NSInteger, HomeworkStatus){
    HomeworkStatusWaitReply = 0,        //等待提交
    HomeworkStatusWaitMark,             //等待批阅
    HomeworkStatusMarked,               //已批阅
};

@interface HomeworkNotificationItem : TNBaseObject
@property (nonatomic, copy)NSString* msgId;
@property (nonatomic, copy)NSString*    eid;
@property (nonatomic, strong)UserInfo*  teacher;
@property (nonatomic, copy)NSString *words;
@property (nonatomic, copy)NSString*    course_name;
@property (nonatomic, assign)HomeworkStatus status;
@property (nonatomic, copy)NSString*    ctime;
@property (nonatomic, copy)NSString* reply_close_ctime;
@property (nonatomic, assign)BOOL hasPhoto;
@property (nonatomic, assign)BOOL hasVoice;
@property (nonatomic, assign)BOOL is_new;
@end
