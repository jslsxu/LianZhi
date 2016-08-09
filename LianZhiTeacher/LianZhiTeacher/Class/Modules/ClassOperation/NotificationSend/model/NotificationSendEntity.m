//
//  NotificationSendEntity.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/7/20.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "NotificationSendEntity.h"

@implementation NotificationSendEntity
- (instancetype)initWithMessageDetailItem:(MessageDetailItem *)detailItem{
    if(self = [super init]){
        self.authorUser = detailItem.author;
        self.content = detailItem.content;
        if(detailItem.videoItem){
            self.videoArray = [NSMutableArray arrayWithObject:detailItem.videoItem];
        }
        if(detailItem.audioItem){
            self.voiceArray = [NSMutableArray arrayWithObject:detailItem.audioItem];
        }
        if(detailItem.photos.count > 0){
            self.imageArray = [NSMutableArray arrayWithArray:detailItem.photos];
        }
        self.timeStr = detailItem.time;
    }
    return self;
}
- (instancetype)init{
    self = [super init];
    if(self){
        self.classArray = [NSMutableArray array];
        self.groupArray = [NSMutableArray array];
        self.voiceArray = [NSMutableArray array];
        self.imageArray = [NSMutableArray array];
        self.videoArray = [NSMutableArray array];
    }
    return self;
}

- (NSMutableArray *)targets{
    NSMutableArray *targetArray = [NSMutableArray array];
    for (ClassInfo *classInfo in self.classArray) {
        for (StudentInfo *studentInfo in classInfo.students) {
            if(studentInfo.selected){
                [targetArray addObject:studentInfo];
            }
        }
    }
    for (TeacherGroup *teacherGroup in self.groupArray) {
        for (TeacherInfo *teacherInfo in teacherGroup.teachers) {
            if(teacherInfo.selected){
                [targetArray addObject:teacherInfo];
            }
        }
    }
    if(targetArray.count)
        return targetArray;
    return nil;
}
- (void)removeTarget:(UserInfo *)userInfo{
    for (ClassInfo *classInfo in self.classArray) {
        for (StudentInfo *studentInfo in classInfo.students) {
            if([studentInfo.uid isEqualToString:userInfo.uid]){
                studentInfo.selected = NO;
            }
        }
    }
    for (TeacherGroup *teacherGroup in self.groupArray) {
        for (TeacherInfo *teacherInfo in teacherGroup.teachers) {
            if([teacherInfo.uid isEqualToString:userInfo.uid]){
                teacherInfo.selected = NO;
            }
        }
    }
}

@end
