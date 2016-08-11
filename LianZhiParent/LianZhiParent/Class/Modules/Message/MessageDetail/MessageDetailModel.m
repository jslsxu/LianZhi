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
    [self modelSetWithJSON:dataWrapper.data];
}

- (BOOL)hasAudio{
    return self.voice.audioUrl.length > 0;
}

- (BOOL)hasPhoto{
    return self.pictures.count > 0;
}

- (BOOL)hasVideo{
    return self.video.videoUrl.length > 0;
}

+ (NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    return @{@"msgID" : @"id",
             };
}

+ (NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{
             @"pictures" : [PhotoItem class],
             };
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
    TNDataWrapper *fromWrapper = [data getDataWrapperForKey:@"from"];
    MessageFromInfo *fromInfo = [[MessageFromInfo alloc] init];
    [fromInfo parseData:fromWrapper];
    self.fromInfo = fromInfo;
    
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
