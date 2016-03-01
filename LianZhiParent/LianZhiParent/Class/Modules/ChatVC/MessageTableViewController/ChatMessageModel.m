//
//  ChatMessageModel.m
//  LianZhiParent
//
//  Created by jslsxu on 15/9/20.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "ChatMessageModel.h"
@implementation ChatMessageModel

//- (BOOL)shouldReload
//{
//    return self.hasNew;
//}
- (instancetype)init
{
    self = [super init];
    if(self)
    {
        _getMoreCount = 0;
    }
    return self;
}

- (BOOL)hasMoreData
{
    return YES;
}

- (BOOL)parseData:(TNDataWrapper *)data type:(REQUEST_TYPE)type
{
    self.hasNew = NO;
    if(type == REQUEST_GETMORE)
        self.getMoreCount ++;
    //获取原来消息列表别人发的最新的消息的id
    NSString *originalLatestID = nil;
    for (NSInteger i = self.modelItemArray.count - 1; i >=0; i--)
    {
        MessageItem *messageItem = self.modelItemArray[i];
        if(messageItem.from == UUMessageFromOther)
        {
            originalLatestID = messageItem.messageContent.mid;
            break;
        }
    }
    
    NSInteger originalNum = self.modelItemArray.count;
    TNDataWrapper *moreWrapper  =[data getDataWrapperForKey:@"more"];
    if(type == REQUEST_REFRESH)
    {
        self.more = [moreWrapper getBoolForKey:@"has"];
    }
    TNDataWrapper *itemsWrapper = [data getDataWrapperForKey:@"items"];
    if(type == REQUEST_REFRESH && itemsWrapper.count > 0)
        self.getHistory = YES;
    else
        self.getHistory = NO;
    if(itemsWrapper.count > 0)
    {
        NSMutableArray *newArray = [NSMutableArray array];
        for (NSInteger i = 0; i < itemsWrapper.count; i++)
        {
            TNDataWrapper *messageWrapper = [itemsWrapper getDataWrapperForIndex:i];
            MessageItem *item = [[MessageItem alloc] init];
            [item parseData:messageWrapper];
            if(item.messageContent.messageType != UUMessageTypeDeleted)
                [newArray addObject:item];
        }
        
        if(type == REQUEST_REFRESH)//下拉
        {
            BOOL hasNew = NO;
            for (NSInteger i = newArray.count - 1; i >=0; i--)
            {
                MessageItem *item = newArray[i];
                if([self canInsert:item])
                {
                    [self.modelItemArray insertObject:item atIndex:0];
                    hasNew = YES;
                }
            }
            if(originalNum == 0)
                self.hasNew = YES;
        }
        else//加载最新
        {
            BOOL hasNew = NO;
            for (MessageItem *item in newArray)
            {
                if([self canInsert:item])
                {
                    [self.modelItemArray addObject:item];
                    hasNew = YES;
                }
            }
            if(self.modelItemArray.count > originalNum)
                self.hasNew = YES;
        }
        [self.modelItemArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            MessageItem *item1 = (MessageItem *)obj1;
            MessageItem *item2 = (MessageItem *)obj2;
            NSInteger item1Time = item1.messageContent.timeInterval;
            NSInteger item2Time = item2.messageContent.timeInterval;
            if(item1Time < item2Time)
                return NSOrderedAscending;
            else if(item1Time == item2Time)
                return NSOrderedSame;
            else
                return NSOrderedDescending;
        }];
    }
    
    for (NSInteger i = 1; i < self.modelItemArray.count; i++)
    {
        MessageItem *preItem = self.modelItemArray[i - 1];
        MessageItem *curItem = self.modelItemArray[i];
        if([curItem.messageContent.ctime isEqualToString:preItem.messageContent.ctime])
            curItem.messageContent.hideTime = YES;
    }
    
    //获取原来消息列表别人发的最新的消息的id
    NSString *curLatestID = nil;
    for (NSInteger i = self.modelItemArray.count - 1; i >=0; i--)
    {
        MessageItem *messageItem = self.modelItemArray[i];
        if(messageItem.from == UUMessageFromOther)
        {
            curLatestID = messageItem.messageContent.mid;
            break;
        }
    }
    if( originalLatestID && [curLatestID compare:originalLatestID] == NSOrderedDescending && !self.soundOff && self.getMoreCount > 1)
    {
        //有新消息，播放声音
        if([UserCenter sharedInstance].personalSetting.soundOn)
            [ApplicationDelegate playSound];
        if([UserCenter sharedInstance].personalSetting.shakeOn)
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }
    if(self.modelItemArray.count > 0)
    {
        MessageItem *firstItem = self.modelItemArray.firstObject;
        MessageItem *lastitem = self.modelItemArray.lastObject;
        self.oldId = firstItem.messageContent.mid;
        self.latestId = lastitem.messageContent.mid;
    }
    if(type == REQUEST_GETMORE)
    {
        self.numOfNew = self.modelItemArray.count - originalNum;
    }

    if(originalNum == 0 && self.modelItemArray.count > 0)
        self.needScrollBottom = YES;
    else
        self.needScrollBottom = NO;
    
    return YES;
}

- (BOOL)canInsert:(MessageItem *)messageItem
{
    for (MessageItem *item in self.modelItemArray)
    {
        if([item.messageContent.mid isEqualToString:messageItem.messageContent.mid])
            return NO;
        NSString *clientID = messageItem.client_send_id;
        if(clientID.length > 0 && ![clientID isEqualToString:@"0"] && [clientID isEqualToString:item.client_send_id])
            return NO;
    }
    return YES;
}
@end
