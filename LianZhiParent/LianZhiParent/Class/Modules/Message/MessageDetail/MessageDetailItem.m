//
//  MessageDetailItem.m
//  LianZhiParent
//
//  Created by qingxu zhou on 16/8/12.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "MessageDetailItem.h"
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
