//
//  PhotoFlowModel.m
//  LianZhiParent
//
//  Created by jslsxu on 14/12/22.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "PhotoFlowModel.h"

@implementation PhotoFlowModel

- (BOOL)hasMoreData
{
    return self.total > self.modelItemArray.count;
}

- (BOOL)parseData:(TNDataWrapper *)data type:(REQUEST_TYPE)type
{
    BOOL parse = [super parseData:data type:type];
    if(type == REQUEST_REFRESH)
    {
        [self.modelItemArray removeAllObjects];
    }
    
    self.total = [data getIntegerForKey:@"total"];
    
    TNDataWrapper *dataArray = [data getDataWrapperForKey:@"pictures"];
    if([dataArray count] > 0)
    {
        for (NSInteger i = 0; i < [dataArray count]; i++) {
            TNDataWrapper *itemInfo = [dataArray getDataWrapperForIndex:i];
            PhotoItem *item = [[PhotoItem alloc] initWithDataWrapper:itemInfo];
            [self.modelItemArray addObject:item];
        }
    }
    return parse;
}
@end
