//
//  VideoItem.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/8/8.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "VideoItem.h"

@implementation VideoItem
+ (NSArray<NSString *> *)modelPropertyBlacklist{
    return @[@"coverImage",@"localVideoPath"];
}

- (NSString *)videoUrl{
    if([_videoUrl hasPrefix:@"/var/mobile"]){
        NSInteger index = 0;
        NSInteger homeIndex = 0;
        for (NSInteger i = 0; i < _videoUrl.length; i++) {
            NSString *s = [_videoUrl substringWithRange:NSMakeRange(i, 1)];
            if([s isEqualToString:@"/"]){
                index++;
                if(index == 7){
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
@end
