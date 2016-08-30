//
//  VideoItem.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/8/8.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "VideoItem.h"

@implementation VideoItem
+ (NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    return @{@"videoID" : @"id"};
}
//+ (NSArray<NSString *> *)modelPropertyBlacklist{
//    return @[@"coverImage",@"localVideoPath"];
//}

- (BOOL)isLocal{
    return self.videoID.length == 0;
}

- (BOOL)isSame:(VideoItem *)object{
    VideoItem *item = (VideoItem *)object;
    if([item.videoID isEqualToString:self.videoID]){
        return YES;
    }
    if([item.videoUrl isEqualToString:self.videoUrl] && item.videoTime == self.videoTime){
        return YES;
    }
    return NO;
}

- (NSString *)filePath{
    if([self isLocal]){
        if([self.videoUrl hasPrefix:@"/var/mobile"]){
            return NSHomeDirectory();
        }
        else{
            return self.videoUrl;
        }
    }
    else{
        return self.videoUrl;
    }
}
@end
