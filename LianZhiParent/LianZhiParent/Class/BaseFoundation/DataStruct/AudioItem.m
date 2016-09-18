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

- (NSString *)audioUrl{
    NSInteger spaceCount = iOS8Later ? 7 : 5;
    if([_audioUrl hasPrefix:@"/var/mobile"]){
        NSInteger index = 0;
        NSInteger homeIndex = 0;
        for (NSInteger i = 0; i < _audioUrl.length; i++) {
            NSString *s = [_audioUrl substringWithRange:NSMakeRange(i, 1)];
            if([s isEqualToString:@"/"]){
                index++;
                if(index == spaceCount){
                    homeIndex = i;
                    break;
                }
            }
        }
        NSString *relativePath = [_audioUrl substringFromIndex:homeIndex + 1];
        return [NSHomeDirectory() stringByAppendingPathComponent:relativePath];
    }
    else{
        return _audioUrl;
    }
    
}
@end
