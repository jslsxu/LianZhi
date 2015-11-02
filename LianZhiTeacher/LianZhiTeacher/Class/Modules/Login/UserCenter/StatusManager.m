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
NSString *const kTimelineNewCommentNotification = @"TimelineNewCommentNotification";

@implementation NoticeItem
- (void)parseData:(TNDataWrapper *)dataWrapper
{
    self.schoolID = [dataWrapper getStringForKey:@"school_id"];
    self.classID = [dataWrapper getStringForKey:@"class_id"];
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
    self.classID = [dataWrapper getStringForKey:@"class_id"];
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
    self.schoolID = [dataWrapper getStringForKey:@"school_id"];
    self.classID = [dataWrapper getStringForKey:@"class_id"];
    self.num = [dataWrapper getIntegerForKey:@"num"];
}

@end

@implementation StatusManager

- (void)parseData:(TNDataWrapper *)dataWrapper
{
    self.changed = [dataWrapper getIntegerForKey:@"changed"];
    self.found = [dataWrapper getBoolForKey:@"found"];
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
    
    TNDataWrapper *newClassFC = [dataWrapper getDataWrapperForKey:@"new_class_fc"];
    if(newClassFC.count > 0)
    {
        TNDataWrapper *classWrapper = [newClassFC getDataWrapperForKey:@"class"];
        if(classWrapper.count > 0)
        {
            NSMutableArray *timelineCommentArray = [NSMutableArray array];
            for (NSInteger i = 0; i < classWrapper.count; i++)
            {
                TNDataWrapper *commentWrapper = [classWrapper getDataWrapperForIndex:i];
                TimelineCommentItem *commentItem = [[TimelineCommentItem alloc] init];
                [commentItem parseData:commentWrapper];
                [timelineCommentArray addObject:commentItem];
            }
            self.classNewCommentArray = timelineCommentArray;
        }
        else
            self.classNewCommentArray = nil;
    }
    else
    {
        self.classNewCommentArray = nil;
    }
    
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
    
    if(self.changed == ChangedTypeSchool)
        [ApplicationDelegate logout];
    else if(self.changed == ChangedTypeCourseAndClass || self.changed == ChangedTypeStudents || self.changed == ChangedTypeFellows)
        [self updateUserInfo];
    [[NSNotificationCenter defaultCenter] postNotificationName:kStatusChangedNotification object:nil userInfo:nil];
    
}

- (void)updateUserInfo
{
    [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"user/get_related_info" method:REQUEST_GET type:REQUEST_REFRESH withParams:nil observer:self completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
        if(responseObject.count > 0)
        {
            [[UserCenter sharedInstance].userData parseData:responseObject];
            [[UserCenter sharedInstance] save];
            [[NSNotificationCenter defaultCenter] postNotificationName:kUserInfoVCNeedRefreshNotificaiotn object:nil];
        }
    } fail:^(NSString *errMsg) {
        
    }];

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
@end
