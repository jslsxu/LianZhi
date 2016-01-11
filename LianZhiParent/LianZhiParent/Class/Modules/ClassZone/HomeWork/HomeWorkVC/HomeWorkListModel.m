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
