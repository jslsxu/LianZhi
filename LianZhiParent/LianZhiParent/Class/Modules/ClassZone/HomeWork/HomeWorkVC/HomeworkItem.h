//
//  HomeworkItem.h
//  LianZhiParent
//
//  Created by qingxu zhou on 16/10/10.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "TNBaseObject.h"
#import "HomeworkNotificationItem.h"
#import "HomeworkStudentAnswer.h"

extern NSString* const kHomeworkItemChangedNotification;

@interface HomeworkItemAnswer : TNBaseObject
@property (nonatomic, copy)NSString*    aid;
@property (nonatomic, copy)NSString*    words;
@property (nonatomic, strong)AudioItem* voice;
@property (nonatomic, strong)NSArray<PhotoItem *>* pics;
@end

@interface HomeworkItem : TNBaseObject
@property (nonatomic, copy)NSString*    homeworkId;
@property (nonatomic, copy)NSString*    eid;
@property (nonatomic, assign)BOOL       etype;
@property (nonatomic, strong)UserInfo*  teacher;
@property (nonatomic, copy)NSString*    words;
@property (nonatomic, strong)AudioItem* voice;
@property (nonatomic, strong)NSArray<PhotoItem *>* pics;
@property (nonatomic, copy)NSString*    ctime;
@property (nonatomic, assign)BOOL       reply_close;
@property (nonatomic, copy)NSString*    reply_close_ctime;
@property (nonatomic, copy)NSString*    course_name;
@property (nonatomic, strong)HomeworkStudentAnswer* s_answer;
@property (nonatomic, copy)NSString*    mark_detail;
@property (nonatomic, copy)NSString*    s_answer_time;
@property (nonatomic, strong)HomeworkItemAnswer*   answer;      //老师的解析
@property (nonatomic, assign)HomeworkStatus status;
- (BOOL)hasPhoto;
- (BOOL)hasAudio;
@end
