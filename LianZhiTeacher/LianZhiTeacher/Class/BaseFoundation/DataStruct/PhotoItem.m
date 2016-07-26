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

+ (NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    return @{@"photoID" : @"id",
             };
}

+ (NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"user" : [UserInfo class]};
}
- (void)parseData:(TNDataWrapper *)dataWrapper
{
    self.photoID = [dataWrapper getStringForKey:@"id"];
    self.small = [dataWrapper getStringForKey:@"small"];
    self.middle = [dataWrapper getStringForKey:@"middle"];
    self.big = [dataWrapper getStringForKey:@"big"];
    self.width = [dataWrapper getFloatForKey:@"width"];
    self.height = [dataWrapper getFloatForKey:@"height"];
    self.uid = [dataWrapper getStringForKey:@"uid"];
    self.can_edit = [dataWrapper getBoolForKey:@"can_edit"];
    TNDataWrapper *userWrapper = [dataWrapper getDataWrapperForKey:@"user"];
    if(userWrapper.count > 0)
    {
        UserInfo *userInfo = [[UserInfo alloc] init];
        [userInfo parseData:userWrapper];
        [self setUser:userInfo];
    }
    self.words = [dataWrapper getStringForKey:@"words"];
    self.time = [dataWrapper getStringForKey:@"time"];
    self.time_str = [dataWrapper getStringForKey:@"time_str"];
    
}

@end
