//
//  LZRankingModel.m
//  LianZhiParent
//
//  Created by Chen Qi on 2016/10/11.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "LZRankingModel.h"

@implementation RankingItem
- (void)parseData:(TNDataWrapper *)dataWrapper
{
    self.rank = [dataWrapper getFloatForKey:@"rank"];
    self.head = [dataWrapper getStringForKey:@"head"];
    self.name = [dataWrapper getStringForKey:@"name"];
    self.score = [dataWrapper getStringForKey:@"score"];
}

@end



@implementation RankingModel

- (void)parseData:(TNDataWrapper *)data
{
    self.total = [data getStringForKey:@"total"];
    self.isTop = [data getIntegerForKey:@"isTop"];
    TNDataWrapper *listWrapper = [data getDataWrapperForKey:@"topThree"];
    
    if (!self.topThree)
    {
        self.topThree = [[TNListModel alloc]init];
    }
    else
    {
        [self.topThree.modelItemArray removeAllObjects];
    }
    
    if(listWrapper.count > 0)
    {
        for (NSInteger i = 0; i < listWrapper.count; i++) {
            RankingItem *item = [[RankingItem alloc] init];
            TNDataWrapper *itemWrapper = [listWrapper getDataWrapperForIndex:i];
            [item parseData:itemWrapper];
            [self.topThree.modelItemArray addObject:item];
        }
    }
    
    listWrapper = [data getDataWrapperForKey:@"rankList"];
    
    if (!self.rankList)
    {
        self.rankList = [[TNListModel alloc]init];
    }
    else
    {
        [self.rankList.modelItemArray removeAllObjects];
    }
    
    if(listWrapper.count > 0)
    {
        for (NSInteger i = 0; i < listWrapper.count; i++) {
            RankingItem *item = [[RankingItem alloc] init];
            TNDataWrapper *itemWrapper = [listWrapper getDataWrapperForIndex:i];
            [item parseData:itemWrapper];
            [self.rankList.modelItemArray addObject:item];
        }
    }

}
@end


