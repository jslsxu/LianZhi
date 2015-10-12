//
//  GrowthTimelineModel.m
//  LianZhiParent
//
//  Created by jslsxu on 15/1/2.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "GrowthTimelineModel.h"

@implementation GrowthTimelineItem
- (void)parseData:(TNDataWrapper *)dataWrapper
{
    self.growthID = [dataWrapper getStringForKey:@"id"];
    self.date = [dataWrapper getStringForKey:@"date"];
    self.time = [dataWrapper getStringForKey:@"time"];
    self.emotion = [dataWrapper getStringForKey:@"mood"];
    self.stoolNum = [dataWrapper getIntegerForKey:@"stool_num"];
    self.temparature = [dataWrapper getStringForKey:@"temperature"];
    self.water = [dataWrapper getBoolForKey:@"water"];
    self.sleep = [dataWrapper getBoolForKey:@"sleep"];
    self.content = [dataWrapper getStringForKey:@"words"];
    self.formatTime = [dataWrapper getStringForKey:@"time_str"];

    TNDataWrapper *teacherWrapper = [dataWrapper getDataWrapperForKey:@"teacher"];
    if([teacherWrapper count] > 0)
    {
        TeacherInfo *teacherInfo = [[TeacherInfo alloc] init];
        [teacherInfo parseData:teacherWrapper];
        [self setTeacherInfo:teacherInfo];
    }
}

@end

@implementation GrowthTimelineModel

- (BOOL)parseData:(TNDataWrapper *)data type:(REQUEST_TYPE)type
{
    BOOL parse = [super parseData:data type:type];
    
    if(type == REQUEST_REFRESH)
        [self.modelItemArray removeAllObjects];
    TNDataWrapper *listWrapper = [data getDataWrapperForKey:@"list"];
    if(listWrapper.count > 0)
    {
        for (NSInteger i = 0; i < listWrapper.count; i++) {
            TNDataWrapper *itemWrapper = [listWrapper getDataWrapperForIndex:i];
            GrowthTimelineItem *item = [[GrowthTimelineItem alloc] init];
            [item parseData:itemWrapper];
            [self.modelItemArray addObject:item];
        }
    }
    return parse;
}
@end
