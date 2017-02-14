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
extern NSString *const kUserInfoVCNeedRefreshNotificaiotn;
extern NSString *const kStatusChangedNotification;

typedef NS_ENUM(NSInteger, ChangedType) {
    ChangedTypeNone = 0,
    ChangedTypeChildren ,
    ChangedTypeSchoolAndClass,
    ChangedTypeFamily
};

@interface NoticeItem : TNModelItem
@property (nonatomic, copy)NSString *childID;
@property (nonatomic, assign)NSInteger num;

@end

@interface TimelineCommentAlertInfo : TNModelItem
@property (nonatomic, copy)NSString *uid;
@property (nonatomic, copy)NSString *avatar;
@property (nonatomic, assign)NSInteger num;

@end

@interface TimelineCommentItem : TNModelItem
@property (nonatomic, copy)NSString *objid;
@property (nonatomic, strong)TimelineCommentAlertInfo *alertInfo;

@end

@interface ClassFeedNotice : TNModelItem
@property (nonatomic, copy)NSString *childID;
@property (nonatomic, copy)NSString *classID;
@property (nonatomic, assign)NSInteger num;

@end

@interface  LeaveInfo :TNModelItem
@property (nonatomic, copy)NSString *classID;
@property (nonatomic, assign)NSInteger num;

@end

@interface StatusManager : TNModelItem
@property (nonatomic, copy)NSString *missionMsg;
@property (nonatomic, assign)ChangedType changed;
@property (nonatomic, assign)BOOL found;
@property (nonatomic, assign)BOOL around;
@property (nonatomic, assign)BOOL faq;
@property (nonatomic, strong)NSArray<NoticeItem *> *notice;
@property (nonatomic, strong)NSArray<ClassFeedNotice *> *classRecordArray;
@property (nonatomic, strong)NSArray<ClassFeedNotice *> *feedClassesNew;
@property (nonatomic, strong)NSArray *classNewCommentArray;
@property (nonatomic, strong)NSArray *treeNewCommentArray;
@property (nonatomic, assign)NSInteger msgNum;
@property (nonatomic, strong)NSDictionary *appExercise;
@property (nonatomic, assign)NSDictionary* appLeave;

- (NSInteger)newCountForClassFeed;
- (NSInteger)newCountForClassRecord;
- (NSInteger)newCountForClassComment;
- (NSInteger)newCountForTreeComment;
- (NSInteger)newCountForNotice;
- (NSInteger)hasNewExerciseForChildID:(NSString *)childID;
- (NSInteger)hasNewAttendanceInfoForChildID:(NSString *)childID;
- (BOOL)hasNewForChildID:(NSString *)childID;
@end
