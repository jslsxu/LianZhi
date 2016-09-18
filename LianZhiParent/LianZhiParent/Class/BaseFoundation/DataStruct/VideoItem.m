//
//  VideoItem.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/8/8.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "VideoItem.h"
#import "NHFileDownloadManager.h"
@implementation VideoItem
+ (NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    return @{@"videoID" : @"id"};
}
+ (NSArray<NSString *> *)modelPropertyBlacklist{
    return @[@"coverImage",@"localVideoPath"];
}

- (NSString *)videoUrl{
    NSInteger spaceCount = iOS8Later ? 7 : 5;
    if([_videoUrl hasPrefix:@"/var/mobile"]){
        NSInteger index = 0;
        NSInteger homeIndex = 0;
        for (NSInteger i = 0; i < _videoUrl.length; i++) {
            NSString *s = [_videoUrl substringWithRange:NSMakeRange(i, 1)];
            if([s isEqualToString:@"/"]){
                index++;
                if(index == spaceCount){
                    homeIndex = i;
                    break;
                }
            }
        }
        NSString *relativePath = [_videoUrl substringFromIndex:homeIndex + 1];
        return [NSHomeDirectory() stringByAppendingPathComponent:relativePath];
    }
    else{
        return _videoUrl;
    }
}

- (BOOL)isLocal{
    return self.videoID.length == 0;
}

- (BOOL)isDownloading{
    if(![self isLocal]){
        return [kNHFileDownloadManager isProcessingWithUrlString:self.videoUrl];
    }
    return NO;
}
@end
