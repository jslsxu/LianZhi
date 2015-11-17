//
//  TreeHouseModel.m
//  LianZhiParent
//
//  Created by jslsxu on 14/12/21.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "TreeHouseModel.h"

@implementation TreehouseItem

- (void)parseData:(TNDataWrapper *)dataWrapper
{
    self.itemID = [dataWrapper getStringForKey:@"id"];
    self.time = [dataWrapper getStringForKey:@"time"];
    self.tag = [dataWrapper getStringForKey:@"tag"];
    self.detail = [dataWrapper getStringForKey:@"words"];
    self.timeStr = [dataWrapper getStringForKey:@"time_str"];
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
    
    TNDataWrapper *authorWrapper = [dataWrapper getDataWrapperForKey:@"user"];
    if(authorWrapper.count > 0)
    {
        UserInfo *userInfo = [[UserInfo alloc] init];
        [userInfo parseData:authorWrapper];
        [self setUser:userInfo];
    }
    
    TNDataWrapper *photoWrapper = [dataWrapper getDataWrapperForKey:@"pictures"];
    if(photoWrapper.count > 0)
    {
        NSMutableArray *photos = [[NSMutableArray alloc] initWithCapacity:0];
        for (NSInteger i = 0; i < photoWrapper.count; i++) {
            TNDataWrapper *photoItemWrapper = [photoWrapper getDataWrapperForIndex:i];
            PhotoItem *item = [[PhotoItem alloc] initWithDataWrapper:photoItemWrapper];
            [photos addObject:item];
        }
        [self setPhotos:photos];
    }
    
    
    self.responseModel = [[ResponseModel alloc] init];
    [self.responseModel parseData:dataWrapper];
    
    self.hasMore = [dataWrapper getBoolForKey:@"comment_more"];
    self.newSend = NO;
}

- (TagPrivilege)tagPrivilege
{
    if(self.audioItem)
        return TagPrivilegeAudio;
    else if(self.photos.count > 0)
        return TagPrivilegePhoto;
    else
        return TagPrivilegeText;
}

- (BOOL)canSendDirectly
{
    for (PhotoItem *item in self.photos) {
        if(item.image)
            return NO;
    }
    return YES;
}

@end

@implementation TreeHouseModel

- (BOOL)hasMoreData
{
    return self.hasMore;
}

- (BOOL)parseData:(TNDataWrapper *)data type:(REQUEST_TYPE)type
{
    BOOL pase = [super parseData:data type:type];
    
    if(type == REQUEST_REFRESH)
    {
        NSMutableArray *deleteArray = [[NSMutableArray alloc] initWithCapacity:0];
        for (TreehouseItem *item in self.modelItemArray) {
            if(!item.newSend)
                [deleteArray addObject:item];
        }
        [self.modelItemArray removeObjectsInArray:deleteArray];
    }
    self.hasMore = [data getBoolForKey:@"has_more"];
    TNDataWrapper *listWrapper = [data getDataWrapperForKey:@"list"];
    for (NSInteger i = 0; i < listWrapper.count; i++) {
        TreehouseItem *item = [[TreehouseItem alloc] init];
        TNDataWrapper *itemWrapper = [listWrapper getDataWrapperForIndex:i];
        [item parseData:itemWrapper];
        [self.modelItemArray addObject:item];
    }
    
    if(self.modelItemArray.count > 0)
    {
        TreehouseItem *lastItem = [self.modelItemArray lastObject];
        self.minID = lastItem.itemID;
    }
    
    return pase;
}

@end
