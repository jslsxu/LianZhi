//
//  HomeworkItem.m
//  LianZhiTeacher
//
//  Created by jslsxu on 16/1/6.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "HomeworkItem.h"

@implementation TargetClass

- (void)parseData:(TNDataWrapper *)dataWrapper
{
    self.classID = [dataWrapper getStringForKey:@"class_id"];
    self.className = [dataWrapper getStringForKey:@"class_name"];
    self.total = [dataWrapper getIntegerForKey:@"total"];
    self.publish = [dataWrapper getIntegerForKey:@"publish"];
    TNDataWrapper *studentsWrapper = [dataWrapper getDataWrapperForKey:@"students"];
    if(studentsWrapper.count > 0) {
        NSMutableArray *students = [NSMutableArray array];
        for (NSInteger i = 0; i < studentsWrapper.count; i++) {
            [students addObject:[studentsWrapper getStringForIndex:i]];
        }
        self.students = students;
    }
}

@end

@implementation HomeWorkItem

- (void)parseData:(TNDataWrapper *)dataWrapper
{
    self.homeworkId = [dataWrapper getStringForKey:@"id"];
    self.words = [dataWrapper getStringForKey:@"words"];
    self.courseName = [dataWrapper getStringForKey:@"course_name"];
    self.fav = [dataWrapper getBoolForKey:@"fav"];
    self.type = [dataWrapper getIntegerForKey:@"ptype"];
    self.ctime = [dataWrapper getIntegerForKey:@"ctime"];
    
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:self.ctime];
    self.weekday = [date weekday];

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM月dd日 HH:mm"];
    self.timeStr = [formatter stringFromDate:date];
    
    TNDataWrapper *jsonWrapper = [dataWrapper getDataWrapperForKey:@"json_str"];
    if(jsonWrapper.count > 0)
    {
        TNDataWrapper *voiceWrapper = [jsonWrapper getDataWrapperForKey:@"voice"];
        if(voiceWrapper.count > 0)
        {
            AudioItem *audioItem = [[AudioItem alloc] init];
            [audioItem parseData:voiceWrapper];
            self.audioItem = audioItem;
        }
        
        TNDataWrapper *photoWrapper = [jsonWrapper getDataWrapperForKey:@"pics"];
        if(photoWrapper.count > 0)
        {
            NSMutableArray *photoArray = [NSMutableArray array];
            for (NSInteger i = 0; i < photoWrapper.count; i++)
            {
                TNDataWrapper *photoItemWrapp = [photoWrapper getDataWrapperForIndex:i];
                PhotoItem *photoItem = [[PhotoItem alloc] init];
                [photoItem parseData:photoItemWrapp];
                [photoArray addObject:photoItem];
            }
            self.photoArray = photoArray;
        }
        
    }
    
    
}

@end
