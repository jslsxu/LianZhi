//
//  PhotoItem.m
//  LianZhiParent
//
//  Created by jslsxu on 14/12/22.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "PhotoItem.h"

#define kThumbnailUrl           @"small"
#define kMiddleUrl              @"middle"
#define kOriginalUrl            @"big"

@implementation PhotoItem

- (id)initWithDataWrapper:(TNDataWrapper *)dataWrapper
{
    self = [super init];
    if(self)
    {
        [self parseData:dataWrapper];
    }
    return self;
}
- (void)parseData:(TNDataWrapper *)dataWrapper
{
    self.photoID = [dataWrapper getStringForKey:@"id"];
    self.thumbnailUrl = [dataWrapper getStringForKey:@"small"];
    self.middleUrl = [dataWrapper getStringForKey:@"middle"];
    self.originalUrl = [dataWrapper getStringForKey:@"big"];
    self.width = [dataWrapper getFloatForKey:@"width"];
    self.height = [dataWrapper getFloatForKey:@"height"];
    self.uid = [dataWrapper getStringForKey:@"uid"];
    self.canDelete = [dataWrapper getBoolForKey:@"can_edit"];
    TNDataWrapper *userWrapper = [dataWrapper getDataWrapperForKey:@"user"];
    if(userWrapper.count > 0)
    {
        UserInfo *userInfo = [[UserInfo alloc] init];
        [userInfo parseData:userWrapper];
        [self setUserInfo:userInfo];
    }
    self.comment = [dataWrapper getStringForKey:@"words"];
    self.time = [dataWrapper getStringForKey:@"time"];
    self.formatTimeStr = [dataWrapper getStringForKey:@"time_str"];
    
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if(self)
    {
        self.thumbnailUrl = [aDecoder decodeObjectForKey:kThumbnailUrl];
        self.middleUrl = [aDecoder decodeObjectForKey:kMiddleUrl];
        self.originalUrl = [aDecoder decodeObjectForKey:kOriginalUrl];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.thumbnailUrl forKey:kThumbnailUrl];
    [aCoder encodeObject:self.middleUrl forKey:kMiddleUrl];
    [aCoder encodeObject:self.originalUrl forKey:kOriginalUrl];
}

@end
