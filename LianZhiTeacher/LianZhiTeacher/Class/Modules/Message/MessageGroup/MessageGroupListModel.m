//
//  MessageGroupListModel.m
//  LianZhiParent
//
//  Created by jslsxu on 14/12/23.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "MessageGroupListModel.h"

#define kAlertSettingList           @"AlertSettingList"


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
    self.soundOn = [[dataWrapper getStringForKey:@"sound"] isEqualToString:@"open"];
    TNDataWrapper *voiceWrapper = [dataWrapper getDataWrapperForKey:@"voice"];
    if(voiceWrapper.count > 0)
    {
        AudioItem *audioItem = [[AudioItem alloc] init];
        [audioItem parseData:voiceWrapper];
        [self setAudioItem:audioItem];
    }
    NSString *sound = [dataWrapper getStringForKey:@"sound"];
    self.soundOn = ([sound isEqualToString:@"open"]);
    self.im_at = [dataWrapper getBoolForKey:@"im_at"];
}
@end

@implementation MessageGroupListModel

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

- (NSArray *)arrayForType:(BOOL)isNotification{
    NSMutableArray *resultArray = [NSMutableArray array];
    for (MessageGroupItem *groupItem in self.modelItemArray) {
        if(groupItem.fromInfo.isNotification == isNotification){
            [resultArray addObject:groupItem];
        }
    }
    return resultArray;
}

- (void)notificationUnreadNumChanged{
    if(self.unreadNumChanged){
        NSInteger notificationNum = 0;
        NSInteger chatnum = 0;
        for (MessageGroupItem *groupItem in self.modelItemArray) {
            if(groupItem.msgNum > 0){
                if(groupItem.fromInfo.isNotification){
                    notificationNum += groupItem.msgNum;
                }
                else{
                    chatnum += groupItem.msgNum;
                }
            }
        }
        self.unreadNumChanged(notificationNum, chatnum);
    }
}

- (BOOL)parseData:(TNDataWrapper *)data type:(REQUEST_TYPE)type
{
    BOOL parse = [super parseData:data type:type];
    
    NSArray *originalMessageArray = [NSArray arrayWithArray:self.modelItemArray];
    if(type == REQUEST_REFRESH)
        [self.modelItemArray removeAllObjects];
//    self.canPublish = [data getBoolForKey:@"can_publish"];
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
                        if(groupItem.fromInfo.type == item.fromInfo.type && [groupItem.fromInfo.uid isEqualToString:item.fromInfo.uid] && ![groupItem.fromInfo.uid isEqualToString:[JSMessagesViewController curChatID]])
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
        if(hasNew)
        {
            //有新消息，播放声音
            if([UserCenter sharedInstance].personalSetting.soundOn)
                [ApplicationDelegate playSound];
            if([UserCenter sharedInstance].personalSetting.shakeOn)
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        }
    }
    [self notificationUnreadNumChanged];
    return parse;
}
@end
