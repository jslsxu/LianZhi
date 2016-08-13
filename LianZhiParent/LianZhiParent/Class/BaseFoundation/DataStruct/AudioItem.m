//
//  AudioItem.m
//  LianZhiParent
//
//  Created by jslsxu on 14/12/24.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "AudioItem.h"

@implementation AudioItem

- (void)dealloc
{
    if(self.audioUrl)
    {
        NSString *filePath = [NSURL fileURLWithPath:[[MLDataCache shareInstance] filePathForKey:self.audioUrl]].absoluteString;
        if([filePath isEqualToString:[MLAmrPlayer shareInstance].filePath.absoluteString])
        {
            [[MLAmrPlayer shareInstance] stopPlaying];
        }
    }
}

- (void)parseData:(TNDataWrapper *)dataWrapper
{
    [self modelSetWithJSON:dataWrapper.data];
}

+ (NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    return @{@"timeSpan" : @"second",
             @"audioUrl" : @"url"};
}
@end
