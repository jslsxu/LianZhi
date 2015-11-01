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
    self.content = [dataWrapper getStringForKey:@"content"];
    
}

@end

@implementation HomeWorkGroup
- (void)parseData:(TNDataWrapper *)dataWrapper
{
    self.dateStr = [dataWrapper getStringForKey:@"date"];
    TNDataWrapper *homeworkWrapper = [dataWrapper getDataWrapperForKey:@"homework"];
    if(homeworkWrapper.count > 0)
    {
        NSMutableArray *homeWorkArray = [NSMutableArray array];
        for (NSInteger i = 0; i < homeworkWrapper.count; i++)
        {
            TNDataWrapper *homeWorkItemWrapper = [homeworkWrapper getDataWrapperForIndex:i];
            HomeWorkHistoryItem *homeWorkItem = [[HomeWorkHistoryItem alloc] init];
            [homeWorkItem parseData:homeWorkItemWrapper];
            [homeWorkArray addObject:homeWorkItem];
        }
        self.homeWorkArray = homeWorkArray;
    }
}

@end

@implementation HomeWorkHistoryModel
- (NSInteger)numOfSections
{
    return self.modelItemArray.count;
}

- (NSInteger)numOfRowsInSection:(NSInteger)section
{
    HomeWorkGroup *group = self.modelItemArray[section];
    return group.homeWorkArray.count;
}

- (TNModelItem *)itemForIndexPath:(NSIndexPath *)indexPath
{
    HomeWorkGroup *group = self.modelItemArray[indexPath.section];
    return group.homeWorkArray[indexPath.row];
}
@end
