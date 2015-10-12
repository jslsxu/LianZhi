//
//  NewMessageModel.m
//  LianZhiParent
//
//  Created by jslsxu on 15/8/22.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "NewMessageModel.h"

@implementation FeedItem
- (void)parseData:(TNDataWrapper *)dataWrapper
{
    self.feedID = [dataWrapper getStringForKey:@"id"];
    self.types = [dataWrapper getIntegerForKey:@"types"];
    self.feedType = [dataWrapper getIntegerForKey:@"content_type"];
    TNDataWrapper *contentWrapper = [dataWrapper getDataWrapperForKey:@"content"];
    self.feedText = [contentWrapper getStringForKey:@"text"];
    self.feedAudio = [contentWrapper getStringForKey:@"voic"];
    self.feedPhoto = [contentWrapper getStringForKey:@"img"];
}

@end

@implementation NewMessageItem

- (void)parseData:(TNDataWrapper *)dataWrapper
{
    TNDataWrapper *userWrapper = [dataWrapper getDataWrapperForKey:@"user"];
    UserInfo *userInfo = [UserInfo alloc];
    [userInfo parseData:userWrapper];
    self.userInfo = userInfo;
    
    self.comment_content = [dataWrapper getStringForKey:@"comment_content"];
    self.ctime = [dataWrapper getStringForKey:@"ctime"];
    TNDataWrapper *moreWrapper = [dataWrapper getDataWrapperForKey:@"more"];
    self.hasMore = [moreWrapper getBoolForKey:@"has"];
    self.lastID = [moreWrapper getStringForKey:@"id"];
    
    TNDataWrapper *feedWrapper = [dataWrapper getDataWrapperForKey:@"feed"];
    FeedItem *feedItem = [[FeedItem alloc] init];
    [feedItem parseData:feedWrapper];
    self.feedItem = feedItem;
}

@end

@implementation NewMessageModel

- (BOOL)hasMoreData
{
    return NO;
}

- (BOOL)parseData:(TNDataWrapper *)data type:(REQUEST_TYPE)type
{
    BOOL parse = [super parseData:data type:type];
    
    if(type == REQUEST_REFRESH)
        [self.modelItemArray removeAllObjects];
    TNDataWrapper *itemsWrapper = [data getDataWrapperForKey:@"items"];
    for (NSInteger i = 0; i < itemsWrapper.count; i++)
    {
        TNDataWrapper *messageItemWrapper = [itemsWrapper getDataWrapperForIndex:i];
        NewMessageItem *messageItem = [[NewMessageItem alloc] init];
        [messageItem parseData:messageItemWrapper];
        [self.modelItemArray addObject:messageItem];
    }
    return parse;
}
@end
