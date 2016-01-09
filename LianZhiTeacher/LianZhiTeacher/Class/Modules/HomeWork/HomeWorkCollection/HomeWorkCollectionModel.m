//
//  HomeWorkCollectionModel.m
//  LianZhiTeacher
//
//  Created by jslsxu on 15/11/27.
//  Copyright © 2015年 jslsxu. All rights reserved.
//

#import "HomeWorkCollectionModel.h"

@implementation HomeWorkCollectionModel


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
    TNDataWrapper *itemListWrapper = [data getDataWrapperForKey:@"items"];
    if(itemListWrapper.count > 0)
    {
        for (NSInteger i = 0; i < itemListWrapper.count; i++)
        {
            TNDataWrapper *homeWorkItemWrapper = [itemListWrapper getDataWrapperForIndex:i];
            HomeWorkItem *item = [[HomeWorkItem alloc] init];
            [item parseData:homeWorkItemWrapper];
            [self.modelItemArray addObject:item];
        }
    }
    return YES;
}
@end
