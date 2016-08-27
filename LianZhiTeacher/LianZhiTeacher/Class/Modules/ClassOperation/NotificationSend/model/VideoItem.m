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
@end
