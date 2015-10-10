//
//  ClassZoneModel.m
//  LianZhiParent
//
//  Created by jslsxu on 14/12/23.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "ClassZoneModel.h"

@implementation ClassZoneItem
- (void)parseData:(TNDataWrapper *)dataWrapper
{
    self.content = [dataWrapper getStringForKey:@"words"];
    self.itemID = [dataWrapper getStringForKey:@"id"];
    self.time = [dataWrapper getStringForKey:@"time"];
    self.formatTime = [dataWrapper getStringForKey:@"time_str"];
    self.canEdit = [dataWrapper getBoolForKey:@"can_edit"];
    self.position = [dataWrapper getStringForKey:@"position"];
    self.longitude = [dataWrapper getFloatForKey:@"longitude"];
    self.latitude = [dataWrapper getFloatForKey:@"latitude"];
    TNDataWrapper *audioWrapper = [dataWrapper getDataWrapperForKey:@"voice"];
    if([audioWrapper count] > 0)
    {
        AudioItem *audioItem = [[AudioItem alloc] init];
        [audioItem parseData:audioWrapper];
        [self setAudioItem:audioItem];
    }
    
    TNDataWrapper *userWrapper = [dataWrapper getDataWrapperForKey:@"user"];
    if(userWrapper && userWrapper.count > 0)
    {
        UserInfo *userInfo = [[UserInfo alloc] init];
        [userInfo parseData:userWrapper];
        self.userInfo = userInfo;
    }
    
    TNDataWrapper *photoWrapper = [dataWrapper getDataWrapperForKey:@"pictures"];
    if(photoWrapper.count > 0)
    {
        NSMutableArray *photosArray = [[NSMutableArray alloc] initWithCapacity:0];
        for (NSInteger i = 0; i < photoWrapper.count; i++) {
            TNDataWrapper *photoItemWrapper = [photoWrapper getDataWrapperForIndex:i];
            PhotoItem *item = [[PhotoItem alloc] initWithDataWrapper:photoItemWrapper];
            [photosArray addObject:item];
        }
        [self setPhotos:photosArray];
    }
    
    self.responseModel = [[ResponseModel alloc] init];
    [self.responseModel parseData:dataWrapper];
}

@end

@implementation ClassZoneModel

- (BOOL)hasMoreData
{
    return self.hasMore;
}

- (BOOL)parseData:(TNDataWrapper *)data type:(REQUEST_TYPE)type
{
    BOOL parse = [super parseData:data type:type];
    if(type == REQUEST_REFRESH)
        [self.modelItemArray removeAllObjects];
    TNDataWrapper *feedListWrapper = [data getDataWrapperForKey:@"feed_list"];
    for (NSInteger i = 0; i < feedListWrapper.count; i++) {
        ClassZoneItem *item = [[ClassZoneItem alloc] init];
        TNDataWrapper *itemWrapper = [feedListWrapper getDataWrapperForIndex:i];
        [item parseData:itemWrapper];
        [self.modelItemArray addObject:item];
    }
    
    self.hasMore = [data getBoolForKey:@"has_more"];
    
    if(self.modelItemArray.count > 0)
    {
        ClassZoneItem *lastitem = [self.modelItemArray lastObject];
        self.minID = lastitem.itemID;
    }
    
    if(type == REQUEST_REFRESH)
    {
        NSString *newsPaper = [data getStringForKey:@"newspaper"];
        [self setNewsPaper:newsPaper];
    }
    return parse;
}
@end
