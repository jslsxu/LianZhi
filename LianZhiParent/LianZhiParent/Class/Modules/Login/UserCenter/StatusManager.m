//
//  StatusManager.m
//  LianZhiParent
//
//  Created by jslsxu on 15/2/10.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "StatusManager.h"
NSString *const kNewMsgNumNotification = @"NewMsgNumNotification";
NSString *const kFoundNotification = @"NewMsgNumNotification";
NSString *const kStatusChangedNotification = @"StatusChangedNotification";
NSString *const kUserInfoVCNeedRefreshNotificaiotn = @"UserInfoVCNeedRefreshNotificaiotn";
@implementation NoticeItem
- (void)parseData:(TNDataWrapper *)dataWrapper
{
    self.childID = [dataWrapper getStringForKey:@"child_id"];
    self.num = [dataWrapper getIntegerForKey:@"num"];
}

@end

@implementation TimelineCommentAlertInfo

- (void)parseData:(TNDataWrapper *)dataWrapper
{
    self.uid = [dataWrapper getStringForKey:@"uid"];
    self.avatar = [dataWrapper getStringForKey:@"head"];
    self.num = [dataWrapper getIntegerForKey:@"num"];
}

@end

@implementation TimelineCommentItem

- (void)parseData:(TNDataWrapper *)dataWrapper
{
    self.objid = [dataWrapper getStringForKey:@"class_id"];
    TNDataWrapper *commentWrapper = [dataWrapper getDataWrapperForKey:@"badge"];
    if(commentWrapper.count > 0)
    {
        TimelineCommentAlertInfo *alertInfo = [[TimelineCommentAlertInfo alloc] init];
        [alertInfo parseData:commentWrapper];
        self.alertInfo = alertInfo;
    }
}

@end

@implementation ClassFeedNotice

- (void)parseData:(TNDataWrapper *)dataWrapper
{
    self.childID = [dataWrapper getStringForKey:@"child_id"];
    self.classID = [dataWrapper getStringForKey:@"class_id"];
    self.num = [dataWrapper getIntegerForKey:@"num"];
}

@end

@implementation LeaveInfo
- (void)parseData:(TNDataWrapper *)dataWrapper
{
    self.classID = [dataWrapper getStringForKey:@"class_id"];
    self.num = [dataWrapper getIntegerForKey:@"num"];
}

@end

@implementation StatusManager

- (void)parseData:(TNDataWrapper *)dataWrapper
{
    TNDataWrapper *practiceWrapper = [dataWrapper getDataWrapperForKey:@"app_exercises"];
    self.appExercise = practiceWrapper.data;
    self.missionMsg = [dataWrapper getStringForKey:@"mission_msg"];
    self.changed = [dataWrapper getIntegerForKey:@"changed"];
    self.found = [dataWrapper getBoolForKey:@"found"];
    self.around = [dataWrapper getBoolForKey:@"around"];
    self.faq = [dataWrapper getBoolForKey:@"faq"];
    TNDataWrapper *newFeedWrapper = [dataWrapper getDataWrapperForKey:@"new_class_feed"];
    if(newFeedWrapper.count == 0)
        self.feedClassesNew = nil;
    else
    {
        NSMutableArray *newFeedsArray = [[NSMutableArray alloc] initWithCapacity:0];
        for (NSInteger i = 0; i < newFeedWrapper.count; i++) {
            TNDataWrapper *feedItemWrapper = [newFeedWrapper getDataWrapperForIndex:i];
            ClassFeedNotice *feedNotice = [[ClassFeedNotice alloc] init];
            [feedNotice parseData:feedItemWrapper];
            [newFeedsArray addObject:feedNotice];
        }
        self.feedClassesNew = newFeedsArray;
    }
    
    TNDataWrapper* leaveWrapper = [dataWrapper getDataWrapperForKey:@"app_nleave"];
    if([leaveWrapper.data isKindOfClass:[NSDictionary class]]){
        self.appLeave = leaveWrapper.data;
    }
    else{
        self.appLeave = nil;
    }
    
    TNDataWrapper *newClassRecordWrapper = [dataWrapper getDataWrapperForKey:@"new_class_record"];
    if(newClassRecordWrapper.count > 0)
    {
        NSMutableArray *newClassRecordArray = [NSMutableArray array];
        for (NSInteger i = 0; i < newClassRecordWrapper.count; i++)
        {
            TNDataWrapper *classRecordItemWrapper = [newClassRecordWrapper getDataWrapperForIndex:i];
            ClassFeedNotice *recordItem = [[ClassFeedNotice alloc] init];
            [recordItem parseData:classRecordItemWrapper];
//            if([recordItem.childID isEqualToString:[UserCenter sharedInstance].curChild.uid])
//                [newClassRecordArray addObject:recordItem];
            [newClassRecordArray addObject:recordItem];
        }
        self.classRecordArray = newClassRecordArray;
    }
    else
        self.classRecordArray = nil;
    
    TNDataWrapper *commentArray = [dataWrapper getDataWrapperForKey:@"new_tree_fc"];
    TNDataWrapper *classCommentWrapper = [commentArray getDataWrapperForKey:@"class"];
    if(classCommentWrapper.count > 0)
    {
        NSMutableArray *classNewCommentArray = [NSMutableArray array];
        for (NSInteger i = 0; i < classCommentWrapper.count; i++)
        {
            TNDataWrapper *itemWrapper = [classCommentWrapper getDataWrapperForIndex:i];
            TimelineCommentItem *commentItem = [[TimelineCommentItem alloc] init];
            [commentItem parseData:itemWrapper];
            [commentItem setObjid:[itemWrapper getStringForKey:@"class_id"]];
            [classNewCommentArray addObject:commentItem];
        }
        self.classNewCommentArray = classNewCommentArray;
    }
    else
        self.classNewCommentArray = nil;
    TNDataWrapper *treeCommentWrapper = [commentArray getDataWrapperForKey:@"tree"];
    if(treeCommentWrapper.count > 0)
    {
        NSMutableArray *treeNewCommentArray = [NSMutableArray array];
        for (NSInteger i = 0; i < treeCommentWrapper.count; i++)
        {
            TNDataWrapper *itemWrapper = [treeCommentWrapper getDataWrapperForIndex:i];
            TimelineCommentItem *commentItem = [[TimelineCommentItem alloc] init];
            [commentItem parseData:itemWrapper];
            [commentItem setObjid:[itemWrapper getStringForKey:@"child_id"]];
            [treeNewCommentArray addObject:commentItem];
//            if([commentItem.objid isEqualToString:[UserCenter sharedInstance].curChild.uid])
//                [treeNewCommentArray addObject:commentItem];
        }
        self.treeNewCommentArray = treeNewCommentArray;
    }
    else
        self.treeNewCommentArray = nil;
    
    TNDataWrapper *noticeWrapper = [dataWrapper getDataWrapperForKey:@"notice"];
    if(noticeWrapper.count == 0)
        self.notice = nil;
    else
    {
        NSMutableArray *noticeArray = [[NSMutableArray alloc] initWithCapacity:0];
        for (NSInteger i = 0; i < noticeWrapper.count; i++) {
            TNDataWrapper *noticeItemWrapper = [noticeWrapper getDataWrapperForIndex:i];
            NoticeItem *noticeItem = [[NoticeItem alloc] init];
            [noticeItem parseData:noticeItemWrapper];
            [noticeArray addObject:noticeItem];
        }
        [self setNotice:noticeArray];
    }
    
    if(self.changed == ChangedTypeChildren)
        [ApplicationDelegate logout];
    else if(self.changed == ChangedTypeFamily || self.changed == ChangedTypeSchoolAndClass){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self updateChildren];
        });
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kStatusChangedNotification object:nil userInfo:nil];
    
}

- (BOOL)isCurChild:(NSString *)classID
{
    for (ClassInfo *classInfo in [UserCenter sharedInstance].curChild.classes)
    {
        if([classID isEqualToString:classInfo.classID])
            return YES;
    }
    return NO;
}

- (void)updateChildren
{
    [[UserCenter sharedInstance] updateChildren];

}

- (void)setMsgNum:(NSInteger)msgNum
{
    _msgNum = msgNum;
    [[NSNotificationCenter defaultCenter] postNotificationName:kNewMsgNumNotification object:nil];
}

- (void)setFound:(BOOL)found
{
    _found = found;
    [[NSNotificationCenter defaultCenter] postNotificationName:kFoundNotification object:nil];
}

- (NSInteger)newCountForClassFeed{
    NSInteger newCount = 0;
    NSArray *classArray = nil;
    for (ChildInfo *childInfo in [UserCenter sharedInstance].children) {
        if([childInfo.uid isEqualToString:[UserCenter sharedInstance].curChild.uid]){
            classArray = childInfo.classes;
        }
    }
    for (ClassFeedNotice *feedNotice in self.feedClassesNew) {
        BOOL isIn = NO;
        for (ClassInfo *classInfo in classArray) {
            if([feedNotice.classID isEqualToString:classInfo.classID]){
                isIn = YES;
            }
        }
        if(isIn){
            newCount += feedNotice.num;
        }
    }
    return newCount;
}
- (NSInteger)newCountForClassRecord{
    NSInteger newCount = 0;
    for (ClassFeedNotice *feedNotice in self.classRecordArray) {
        if([feedNotice.childID isEqualToString:[UserCenter sharedInstance].curChild.uid]){
            newCount += feedNotice.num;
        }
    }
    return newCount;
}
- (NSInteger)newCountForClassComment{
    NSInteger newCount = 0;
//    for (TimelineCommentItem *commentItem in self.classNewCommentArray) {
//        if([commentItem.objid isEqualToString:[UserCenter sharedInstance].curChild.uid]){
//            newCount += commentItem.alertInfo.num;
//        }
//    }
    
    for (ClassInfo *classInfo in [UserCenter sharedInstance].curChild.classes)
    {
        NSString *classID = classInfo.classID;
        for (TimelineCommentItem *item in self.classNewCommentArray)
        {
            if([item.objid isEqualToString:classID])
            {
                newCount += item.alertInfo.num;
            }
        }
    }

    return newCount;
}

- (NSInteger)newCountForTreeComment{
    NSInteger newCount = 0;
    for (TimelineCommentItem *commentItem in self.treeNewCommentArray) {
        if([commentItem.objid isEqualToString:[UserCenter sharedInstance].curChild.uid]){
            newCount += commentItem.alertInfo.num;
        }
    }
    return newCount;
}

- (NSInteger)newCountForNotice{
    NSInteger newCount = 0;
    for (NoticeItem *noticeItem in self.notice) {
        if([noticeItem.childID isEqualToString:[UserCenter sharedInstance].curChild.uid]){
            newCount += noticeItem.num;
        }
    }
    return newCount;
}

- (NSInteger)hasNewExerciseForChildID:(NSString *)childID{
    NSNumber *num = self.appExercise[childID];
    return [num integerValue];
}

- (NSInteger)hasNewAttendanceInfoForChildID:(NSString *)childID{
    NSDictionary* attendanceInfo = self.appLeave[childID];
    NSInteger num = 0;
    NSArray* classArray = [UserCenter sharedInstance].curChild.classes;
    for (NSString* key in attendanceInfo.allKeys) {
        BOOL inClass = NO;
        for (ClassInfo *classInfo in classArray) {
            if([classInfo.classID isEqualToString:key]){
                inClass = YES;
            }
        }
        if(inClass){
            num += [attendanceInfo[key] integerValue];
        }
    }
    return num;
}

- (BOOL)hasNewForChildID:(NSString *)childID{
    NSInteger newCount = 0;
    for (NoticeItem *noticeItem in self.notice) {
        if([noticeItem.childID isEqualToString:childID]){
            newCount += noticeItem.num;
        }
    }
    
    NSArray *classArray = nil;
    for (ChildInfo *childInfo in [UserCenter sharedInstance].children) {
        if([childInfo.uid isEqualToString:childID]){
            classArray = childInfo.classes;
        }
    }
    for (ClassFeedNotice *feedNotice in self.feedClassesNew) {
        BOOL isIn = NO;
        for (ClassInfo *classInfo in classArray) {
            if([feedNotice.classID isEqualToString:classInfo.classID]){
                isIn = YES;
            }
        }
        if(isIn){
            newCount += feedNotice.num;
        }
    }
    
    for (ClassFeedNotice *feedNotice in self.classRecordArray) {
        if([feedNotice.childID isEqualToString:childID]){
            newCount += feedNotice.num;
        }
    }
    
    for (ChildInfo *childInfo in [UserCenter sharedInstance].children) {
        if([childInfo.uid isEqualToString:childID]){
            NSArray *classArray = [childInfo classes];
            for (ClassInfo *classInfo in classArray)
            {
                NSString *classID = classInfo.classID;
                for (TimelineCommentItem *item in self.classNewCommentArray)
                {
                    if([item.objid isEqualToString:classID])
                    {
                        newCount += item.alertInfo.num;
                    }
                }
            }
        }
    }
    
    for (TimelineCommentItem *commentItem in self.treeNewCommentArray) {
        if([commentItem.objid isEqualToString:childID]){
            newCount += commentItem.alertInfo.num;
        }
    }
    
    newCount += [self hasNewExerciseForChildID:childID];
    newCount += [self hasNewExerciseForChildID:childID];
    return newCount;
}

- (void)clean
{
    self.changed = NO;
    self.found = NO;
    self.notice = nil;
    self.feedClassesNew = nil;
    self.msgNum = 0;
}
@end
