//
//  HomeWorkHistoryModel.m
//  LianZhiTeacher
//
//  Created by jslsxu on 15/10/31.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "HomeWorkHistoryModel.h"

@implementation HomeWorkHistoryItem

- (void)parseData:(TNDataWrapper *)dataWrapper
{
    self.homeworkId = [dataWrapper getStringForKey:@"id"];
    self.words = [dataWrapper getStringForKey:@"words"];
    self.courseName = [dataWrapper getStringForKey:@"course_name"];
    self.fav = [dataWrapper getBoolForKey:@"fav"];
    self.type = [dataWrapper getIntegerForKey:@"ptype"];
    
    TNDataWrapper *voiceWrapper = [dataWrapper getDataWrapperForKey:@"voice"];
    if(voiceWrapper.count > 0)
    {
        AudioItem *audioItem = [[AudioItem alloc] init];
        [audioItem parseData:voiceWrapper];
        self.audioItem = audioItem;
    }
    
    TNDataWrapper *photoWrapper = [dataWrapper getDataWrapperForKey:@"pics"];
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

@end


@implementation HomeWorkHistoryModel

- (BOOL)parseData:(TNDataWrapper *)data type:(REQUEST_TYPE)type
{
    return YES;
}
@end
