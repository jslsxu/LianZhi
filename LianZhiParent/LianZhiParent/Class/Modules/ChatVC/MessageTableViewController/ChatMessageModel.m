//
//  ChatMessageModel.m
//  LianZhiParent
//
//  Created by jslsxu on 15/9/20.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "ChatMessageModel.h"
@implementation ChatMessageModel

- (BOOL)hasMoreData
{
    return YES;
}

- (BOOL)parseData:(TNDataWrapper *)data type:(REQUEST_TYPE)type
{
    self.hasNew = NO;
    NSInteger originalNum = self.modelItemArray.count;
    TNDataWrapper *moreWrapper  =[data getDataWrapperForKey:@"more"];
    if(type == REQUEST_REFRESH)
    {
        self.more = [moreWrapper getBoolForKey:@"has"];
    }
    TNDataWrapper *itemsWrapper = [data getDataWrapperForKey:@"items"];
    if(itemsWrapper.count > 0)
    {
        NSMutableArray *newArray = [NSMutableArray array];
        for (NSInteger i = 0; i < itemsWrapper.count; i++)
        {
            TNDataWrapper *messageWrapper = [itemsWrapper getDataWrapperForIndex:i];
            MessageItem *item = [[MessageItem alloc] init];
            [item parseData:messageWrapper];
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
            self.shouldReload = hasNew;
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
            self.shouldReload = hasNew;
            if(self.modelItemArray.count > originalNum)
                self.hasNew = YES;
        }
        [self.modelItemArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            MessageItem *item1 = (MessageItem *)obj1;
            MessageItem *item2 = (MessageItem *)obj2;
            return [item1.messageContent.ctime compare:item2.messageContent.ctime];
        }];
    }
    if(type == REQUEST_REFRESH)
    {
        MessageItem *firstItem = self.modelItemArray.firstObject;
        self.oldId = firstItem.messageContent.mid;
    }
    else
    {
        MessageItem *lastitem = self.modelItemArray.lastObject;
        self.latestId = lastitem.messageContent.mid;
    }
    return YES;
}

- (BOOL)canInsert:(MessageItem *)messageItem
{
    for (MessageItem *item in self.modelItemArray)
    {
        if([item.messageContent.mid isEqualToString:messageItem.messageContent.mid])
            return NO;
    }
    return YES;
}
@end
