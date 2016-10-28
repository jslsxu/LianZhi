//
//  HomeworkItem.h
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/10/17.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "TNBaseObject.h"
#import "HomeworkStudentAnswer.h"
typedef NS_ENUM(NSInteger, HomeworkStudentStatus){
    HomeworkStudentStatusUnread,            //学生未读
    HomeworkStudentStatusRead,              //已读
    HomeworkStudentStatusWaitMark,          //等待批阅
    HomeworkStudentStatusHasMark,           //已批阅
};

@interface HomeworkStudentInfo : TNBaseObject
@property (nonatomic, strong)StudentInfo* student;
@property (nonatomic, copy)NSString*        classId;
@property (nonatomic, copy)NSString*        className;
@property (nonatomic, assign)HomeworkStudentStatus status;
@property (nonatomic, assign)BOOL unread_t;
@property (nonatomic, strong)HomeworkStudentAnswer* s_answer;
@property (nonatomic, copy)NSString*        s_answer_time;
@property (nonatomic, copy)NSString*        mark_detail;
@end

@interface HomeworkClassStatus : TNBaseObject
@property (nonatomic, strong)NSArray<HomeworkStudentInfo *>* students;
@property (nonatomic, copy)NSString*    classID;
@property (nonatomic, copy)NSString*    logo;
@property (nonatomic, copy)NSString*    name;
@property (nonatomic, assign)NSInteger  send;
@property (nonatomic, assign)NSInteger  reply;
@property (nonatomic, assign)NSInteger  mark;
- (BOOL)canNotification;
@end

@interface HomeworkItemAnswer : TNBaseObject
@property (nonatomic, copy)NSString*    aid;
@property (nonatomic, copy)NSString*    words;
@property (nonatomic, strong)AudioItem* voice;
@property (nonatomic, strong)NSArray<PhotoItem *>* pics;
@end

@interface HomeworkItem : TNBaseObject
@property (nonatomic, copy)NSString *   eid;
@property (nonatomic, copy)NSString*    ctime;
@property (nonatomic, copy)NSString*    course_name;
@property (nonatomic, assign)BOOL       etype;
@property (nonatomic, assign)BOOL       reply_close;
@property (nonatomic, copy)NSString*    reply_close_ctime;
@property (nonatomic, assign)NSInteger  publish_num;
@property (nonatomic, assign)NSInteger  reply_num;
@property (nonatomic, assign)NSInteger  marking_num;
@property (nonatomic, assign)NSInteger  read_num;
@property (nonatomic, strong)NSArray<HomeworkClassStatus *>* classes;
@property (nonatomic, strong)AudioItem* voice;
@property (nonatomic, strong)NSArray<PhotoItem *>*  pics;
@property (nonatomic, copy)NSString*    words;
@property (nonatomic, strong)HomeworkItemAnswer*   answer;
- (BOOL)hasImage;
- (BOOL)hasAudio;
@end
