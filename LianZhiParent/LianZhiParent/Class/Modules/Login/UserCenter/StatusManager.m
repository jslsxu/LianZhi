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

@implementation StatusManager

- (void)parseData:(TNDataWrapper *)dataWrapper
{
    self.changed = [dataWrapper getIntegerForKey:@"changed"];
    self.found = [dataWrapper getBoolForKey:@"found"];
    TNDataWrapper *newFeedWrapper = [dataWrapper getDataWrapperForKey:@"new_class_feed"];
    if(newFeedWrapper.count == 0)
        self.feedClassesNew = nil;
    else
    {
        NSMutableArray *newFeedsArray = [[NSMutableArray alloc] initWithCapacity:0];
        for (NSInteger i = 0; i < newFeedWrapper.count; i++) {
            NSString *classID = [newFeedWrapper getStringForIndex:i];
            [newFeedsArray addObject:classID];
        }
        self.feedClassesNew = newFeedsArray;
    }
    
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
            [commentItem setObjid:[itemWrapper getStringForKey:@"child_id"]];
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
    else if(self.changed == ChangedTypeFamily || self.changed == ChangedTypeSchoolAndClass)
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

- (void)clean
{
    self.changed = NO;
    self.found = NO;
    self.notice = nil;
    self.feedClassesNew = nil;
    self.msgNum = 0;
}
@end
