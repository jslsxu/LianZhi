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
            HomeWorkItem *homeWorkItem = [[HomeWorkItem alloc] init];
            [homeWorkItem parseData:homeWorkItemWrapper];
            [homeWorkArray addObject:homeWorkItem];
        }
        self.homeWorkArray = homeWorkArray;
    }
}

@end

@implementation HomeWorkListModel

- (id)init
{
    self = [super init];
    if(self)
    {
        for (NSInteger i = 0; i < 4; i++)
        {
            HomeWorkGroup *group = [[HomeWorkGroup alloc] init];
            [group setDateStr:@"1233333"];
            NSMutableArray *itemArray = [NSMutableArray array];
            for (NSInteger j = 0; j < 3; j++)
            {
                HomeWorkItem *item = [[HomeWorkItem alloc] init];
                [item setContent:@"谁来看一下这道题怎么解啊？"];
                [itemArray addObject:item];
            }
            group.homeWorkArray = itemArray;
            [self.modelItemArray addObject:group];
        }
    }
    return self;
}

- (BOOL)hasMoreData
{
    return NO;
}

- (BOOL)parseData:(TNDataWrapper *)data type:(REQUEST_TYPE)type
{
    return YES;
}

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
