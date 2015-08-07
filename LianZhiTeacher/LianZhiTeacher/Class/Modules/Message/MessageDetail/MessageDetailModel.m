//
//  MessageDetailModel.m
//  LianZhiParent
//
//  Created by jslsxu on 14/12/24.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "MessageDetailModel.h"

@implementation MessageDetailItem
- (void)parseData:(TNDataWrapper *)dataWrapper
{
    self.msgID = [dataWrapper getStringForKey:@"id"];
    self.time = [dataWrapper getStringForKey:@"time"];
    self.content = [dataWrapper getStringForKey:@"words"];
    self.timeStr = [dataWrapper getStringForKey:@"time_str"];
    TNDataWrapper *audioWrapper = [dataWrapper getDataWrapperForKey:@"voice"];
    if(audioWrapper && [audioWrapper count] > 0)
    {
        AudioItem *audioItem = [[AudioItem alloc] init];
        [audioItem parseData:audioWrapper];
        [self setAudioItem:audioItem];
    }
}

- (void)dealloc
{
    
}

@end

@implementation MessageDetailModel
- (BOOL)hasMoreData
{
    return self.hasMore;
}

- (NSString *)minID
{
    MessageDetailItem *lastItem = [self.modelItemArray lastObject];
    return lastItem.msgID;
}

- (BOOL)parseData:(TNDataWrapper *)data type:(REQUEST_TYPE)type
{
    BOOL parse = [super parseData:data type:type];
    
    if(type == REQUEST_REFRESH)
        [self.modelItemArray removeAllObjects];
    self.hasMore = [data getBoolForKey:@"has_next"];
    TNDataWrapper *listWrapper = [data getDataWrapperForKey:@"list"];
    for (NSInteger i = 0; i < listWrapper.count; i++) {
        MessageDetailItem *item = [[MessageDetailItem alloc] init];
        TNDataWrapper *detailWrapper = [listWrapper getDataWrapperForIndex:i];
        [item parseData:detailWrapper];
        [self.modelItemArray addObject:item];
    }
    return parse;
}
@end
