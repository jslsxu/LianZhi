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
    
    TNDataWrapper *photoWrapper = [dataWrapper getDataWrapperForKey:@"pictures"];
    if(photoWrapper.count)
    {
        NSMutableArray *photoArray = [NSMutableArray array];
        for (NSInteger i = 0; i < photoWrapper.count; i++)
        {
            TNDataWrapper *photoItemWrapper = [photoWrapper getDataWrapperForIndex:i];
            PhotoItem *photoItem = [[PhotoItem alloc] init];
            [photoItem parseData:photoItemWrapper];
            [photoArray addObject:photoItem];
        }
        self.photos = photoArray;
    }
    
    TNDataWrapper *userWrapper = [dataWrapper getDataWrapperForKey:@"from_user"];
    if(userWrapper.count > 0)
    {
        UserInfo *userInfo = [[UserInfo alloc] init];
        [userInfo parseData:userWrapper];
        self.author = userInfo;
    }
}

- (BOOL)hasAudio{
    return self.audioItem;
}

- (BOOL)hasPhoto{
    return self.photos.count > 0;
}

- (BOOL)hasVideo{
    return self.videoItem;
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
    TNDataWrapper *fromDataWrapper = [data getDataWrapperForKey:@"from"];
    if(fromDataWrapper.count > 0){
        MessageFromInfo *fromInfo = [[MessageFromInfo alloc] init];
        [fromInfo parseData:fromDataWrapper];
        self.fromInfo = fromInfo;
    }
    TNDataWrapper *listWrapper = [data getDataWrapperForKey:@"list"];
    for (NSInteger i = 0; i < listWrapper.count; i++) {
        MessageDetailItem *item = [[MessageDetailItem alloc] init];
        TNDataWrapper *detailWrapper = [listWrapper getDataWrapperForIndex:i];
        [item parseData:detailWrapper];
        [item setAvatarUrl:self.avatarUrl];
        [self.modelItemArray addObject:item];
    }
    return parse;
}
@end
