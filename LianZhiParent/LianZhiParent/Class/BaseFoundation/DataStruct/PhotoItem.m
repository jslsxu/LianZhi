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
+ (nullable NSArray<NSString *> *)modelPropertyBlacklist{
    return @[@"publishImageItem"];
}
- (void)parseData:(TNDataWrapper *)dataWrapper
{
    [self modelSetWithJSON:dataWrapper.data];
    
}

@end
