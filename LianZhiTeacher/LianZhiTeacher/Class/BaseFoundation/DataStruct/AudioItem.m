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

+ (NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    return @{@"audioID" : @"id",
             @"timeSpan" : @"second",
             @"audioUrl" : @"url"};
}

- (void)parseData:(TNDataWrapper *)dataWrapper
{
    [self modelSetWithJSON:dataWrapper.data];
}

- (BOOL)isLocal{
    return self.audioID.length == 0;
}

- (BOOL)isSame:(AudioItem *)object{
    if([object.audioID isEqualToString:self.audioID]){
        return YES;
    }
    if([object.audioUrl isEqualToString:self.audioUrl] && object.timeSpan == self.timeSpan){
        return YES;
    }
    return NO;
}
@end
