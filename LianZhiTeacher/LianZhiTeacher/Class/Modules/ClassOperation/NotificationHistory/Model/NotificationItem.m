//
//  NotificationItem.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/8/10.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "NotificationItem.h"

@implementation NotificationItem

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    return @{@"nid" : @"id",
             @"classes" : @"target.classes",
             @"groups" : @"target.groups"};
}

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{
             @"pictures" : [PhotoItem class],
             @"classes" : [ClassInfo class],
             @"groups" : [TeacherGroup class]};
}

+ (NSArray<NSString *> *)modelPropertyBlacklist{
    return @[@"user"];
}

- (BOOL)hasImage{
    return self.pictures.count > 0;
}

- (BOOL)hasAudio{
    return self.voice.audioUrl.length > 0;
}

- (BOOL)hasVideo{
    return self.video.videoUrl.length > 0;
}

- (NSArray *)targetArray{
    NSMutableArray *targetList = [NSMutableArray array];
    if(self.classes.count > 0){
        [targetList addObjectsFromArray:self.classes];
    }
    if(self.groups.count > 0){
        [targetList addObjectsFromArray:self.groups];
    }
    return targetList;
}

+ (NotificationItem *)convertFromMessageItem:(MessageDetailItem *)messageItem{
    NotificationItem *notificationItem = [[NotificationItem alloc] init];
    [notificationItem setNid:messageItem.msgID];
    [notificationItem setWords:messageItem.words];
    [notificationItem setUser:messageItem.from_user];
    [notificationItem setCreated_time:messageItem.time_str];
    [notificationItem setVideo:messageItem.video];
    [notificationItem setVoice:messageItem.voice];
    [notificationItem setPictures:messageItem.pictures];
    return notificationItem;
}

@end
