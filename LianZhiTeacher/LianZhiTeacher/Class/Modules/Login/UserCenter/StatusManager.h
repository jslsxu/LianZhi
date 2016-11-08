//
//  StatusManager.h
//  LianZhiParent
//
//  Created by jslsxu on 15/2/10.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "TNModelItem.h"
extern NSString *const kNewMsgNumNotification;
extern NSString *const kFoundNotification;
extern NSString *const kUserInfoContactsChangedNotificaiotn;
extern NSString *const kStatusChangedNotification;
extern NSString *const kTimelineNewCommentNotification;

typedef NS_ENUM(NSInteger, ChangedType) {
    ChangedTypeNone = 0,
    ChangedTypeSchool ,
    ChangedTypeCourseAndClass,
    ChangedTypeStudents,
    ChangedTypeFellows,
};

@interface NoticeItem : TNModelItem
@property (nonatomic, copy)NSString *schoolID;
@property (nonatomic, copy)NSString *classID;
@property (nonatomic, assign)NSInteger num;

@end

@interface TimelineCommentAlertInfo : TNModelItem
@property (nonatomic, copy)NSString *uid;
@property (nonatomic, copy)NSString *avatar;
@property (nonatomic, assign)NSInteger num;

@end

@interface TimelineCommentItem : TNModelItem
@property (nonatomic, copy)NSString *classID;
@property (nonatomic, strong)TimelineCommentAlertInfo *alertInfo;

@end

@interface ClassFeedNotice : TNModelItem
@property (nonatomic, copy)NSString *schoolID;
@property (nonatomic, copy)NSString *classID;
@property (nonatomic, assign)NSInteger num;

@end

@interface StatusManager : TNModelItem
@property (nonatomic, copy)NSString *missionMsg;
@property (nonatomic, assign)ChangedType changed;
@property (nonatomic, assign)BOOL found;            //发现是否有更新
@property (nonatomic, assign)BOOL around;           //身边事是否有更新
@property (nonatomic, assign)BOOL faq;
@property (nonatomic, strong)NSArray *notice;
@property (nonatomic, strong)NSArray *feedClassesNew;
//新动态
@property (nonatomic, strong)NSArray *classNewCommentArray;

@property (nonatomic, assign)NSInteger msgNum;
@property (nonatomic, strong)NSDictionary*  appExercise;
@property (nonatomic, strong)NSDictionary *appLeave;
@property (nonatomic, assign)NSInteger leaveNum;
- (NSInteger)hasNewForClassFeed;
- (NSInteger)hasNewForClassComment;
- (NSInteger)newHomeworkNumForSchool:(NSString *)schoolID;
- (NSInteger)hasNewForSchool:(NSString *)schoolID;
@end
