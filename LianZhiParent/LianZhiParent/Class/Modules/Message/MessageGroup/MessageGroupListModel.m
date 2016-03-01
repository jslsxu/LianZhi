//
//  MessageGroupListModel.m
//  LianZhiParent
//
//  Created by jslsxu on 14/12/23.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "MessageGroupListModel.h"

#define kAlertSettingList           @"AlertSettingList"

@implementation MessageFromInfo
- (void)parseData:(TNDataWrapper *)dataWrapper
{
    self.uid = [dataWrapper getStringForKey:@"id"];
    self.logoUrl = [dataWrapper getStringForKey:@"logo"];
    self.name = [dataWrapper getStringForKey:@"name"];
    self.type = [dataWrapper getIntegerForKey:@"type"];
    self.label = [dataWrapper getStringForKey:@"label"];
    self.from_obj_id = [dataWrapper getStringForKey:@"from_obj_id"];
    self.mobile = [dataWrapper getStringForKey:@"mobile"];
    self.classID = [dataWrapper getStringForKey:@"class_id"];
    self.childID = [dataWrapper getStringForKey:@"child_id"];
}

- (BOOL)isNotification
{
    if(self.type == ChatTypeClass || self.type == ChatTypeParents||self.type == ChatTypeTeacher || self.type == ChatTypeGroup || self.type == ChatTypeAttendance || self.type == ChatTypePractice)
        return NO;
    return YES;
}
@end

@implementation MessageGroupItem
- (void)parseData:(TNDataWrapper *)dataWrapper
{
    MessageFromInfo *fromInfo = [[MessageFromInfo alloc] init];
    TNDataWrapper *fromInfoWrapper = [dataWrapper getDataWrapperForKey:@"from"];
    [fromInfo parseData:fromInfoWrapper];
    [self setFromInfo:fromInfo];
    
    self.formatTime = [dataWrapper getStringForKey:@"time_str"];
    self.content = [dataWrapper getStringForKey:@"words"];
    self.msgNum = [dataWrapper getIntegerForKey:@"unread"];
//    self.soundOn = ![[DataCenter sharedInstance] checkFromIDSilence:self.fromInfo.uid];
    NSString *sound = [dataWrapper getStringForKey:@"sound"];
    self.soundOn = ([sound isEqualToString:@"open"]);
    
}
@end

@implementation MessageGroupListModel

- (BOOL)hasMoreData
{
    return YES;
}

- (BOOL)parseData:(TNDataWrapper *)data type:(REQUEST_TYPE)type
{
    BOOL parse = [super parseData:data type:type];
    NSArray *originalMessageArray = [NSArray arrayWithArray:self.modelItemArray];
    if(type == REQUEST_REFRESH)
        [self.modelItemArray removeAllObjects];
    TNDataWrapper *listWrapper = [data getDataWrapperForKey:@"list"];
    if(listWrapper.count > 0)
    {
        BOOL hasNew = NO;//是否有新消息
        for (NSInteger i = 0; i < listWrapper.count; i++)
        {
            MessageGroupItem *item = [[MessageGroupItem alloc] init];
            TNDataWrapper *itemWrapper = [listWrapper getDataWrapperForIndex:i];
            [item parseData:itemWrapper];
            [self.modelItemArray addObject:item];
            
            if(originalMessageArray.count > 0)
            {
                BOOL isNewMessage = [self isNewMessage:item inArray:originalMessageArray];//是否是新的需要提醒的消息
                if(isNewMessage)
                    hasNew = YES;
                else
                {
                    //判断是否是原来的消息中，但是新消息数增加了
                    for (MessageGroupItem *groupItem in originalMessageArray)
                    {
                        MessageFromInfo *from = groupItem.fromInfo;
                        if(from.type == item.fromInfo.type && [from.uid isEqualToString:item.fromInfo.uid] && ![from.uid isEqualToString:[JSMessagesViewController curChatID]])
                        {
                            NSInteger originalNum = groupItem.msgNum;
                            if(item.msgNum > originalNum && item.soundOn)
                                hasNew = YES;
                            break;
                        }
                    }
                }
            }
        }
        if(originalMessageArray.count < self.modelItemArray.count)
            hasNew = YES;
        if(hasNew)
        {
            //有新消息，播放声音
            if([UserCenter sharedInstance].personalSetting.soundOn)
                [ApplicationDelegate playSound];
            if([UserCenter sharedInstance].personalSetting.shakeOn)
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        }
    }
    return parse;
}

- (BOOL)isNewMessage:(MessageGroupItem *)groupItem inArray:(NSArray *)originalArray
{
    BOOL isNew = YES;
    for (MessageGroupItem *groupItem in originalArray)
    {
        if([groupItem.fromInfo.uid isEqualToString:groupItem.fromInfo.uid] || [groupItem.fromInfo.uid isEqualToString:[JSMessagesViewController curChatID]])
        {
            isNew = NO;
            break;
        }
    }
    if(isNew)
    {
        if(groupItem.soundOn && groupItem.msgNum > 0)
            return YES;
    }
    return NO;
}

@end
