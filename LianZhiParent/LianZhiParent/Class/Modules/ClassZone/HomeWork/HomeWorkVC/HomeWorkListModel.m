//
//  HomeWorkListModel.m
//  LianZhiParent
//
//  Created by jslsxu on 15/10/26.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "HomeWorkListModel.h"

@implementation HomeWorkItem

- (void)parseData:(TNDataWrapper *)dataWrapper
{
    self.homeworkId = [dataWrapper getStringForKey:@"id"];
    self.words = [dataWrapper getStringForKey:@"words"];
    self.courseName = [dataWrapper getStringForKey:@"course_name"];
    self.fav = [dataWrapper getBoolForKey:@"fav"];
    self.type = [dataWrapper getIntegerForKey:@"ptype"];
    self.ctime = [dataWrapper getIntegerForKey:@"ctime"];
    self.teacherName = [dataWrapper getStringForKey:@"uname"];
//    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:self.ctime];
//    self.weekday = [date weekday];
    
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"MM月dd日 HH:mm"];
//    self.timeStr = [formatter stringFromDate:date];
    
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

@implementation HomeWorkListModel

- (BOOL)hasMoreData
{
    return self.has;
}

- (BOOL)parseData:(TNDataWrapper *)data type:(REQUEST_TYPE)type
{
    if(type == REQUEST_REFRESH)
        [self.modelItemArray removeAllObjects];
    TNDataWrapper *moreWrapper = [data getDataWrapperForKey:@"more"];
    self.has = [moreWrapper getBoolForKey:@"has"];
    self.maxID = [moreWrapper getStringForKey:@"id"];
    
    TNDataWrapper *itemsWrapper = [data getDataWrapperForKey:@"items"];
    if(itemsWrapper.count > 0)
    {
        for (NSInteger i = 0; i < itemsWrapper.count; i++)
        {
            TNDataWrapper *itemWrapper = [itemsWrapper getDataWrapperForIndex:i];
            HomeWorkItem *item = [[HomeWorkItem alloc] init];
            [item parseData:itemWrapper];
            [self.modelItemArray addObject:item];
        }
    }
    return YES;
}

@end
