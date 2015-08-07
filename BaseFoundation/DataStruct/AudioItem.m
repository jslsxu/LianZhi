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
    NSString *filePath = [NSURL fileURLWithPath:[[MLDataCache shareInstance] filePathForKey:self.audioUrl]].absoluteString;
    if([filePath isEqualToString:[MLAmrPlayer shareInstance].filePath.absoluteString])
    {
        [[MLAmrPlayer shareInstance] stopPlaying];
    }
}

- (void)parseData:(TNDataWrapper *)dataWrapper
{
    self.timeSpan = [dataWrapper getIntegerForKey:@"second"];
    self.audioUrl = [dataWrapper getStringForKey:@"url"];
}
@end
