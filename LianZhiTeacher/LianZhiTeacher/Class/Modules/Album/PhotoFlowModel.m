//
//  PhotoFlowModel.m
//  LianZhiParent
//
//  Created by jslsxu on 14/12/22.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "PhotoFlowModel.h"

@implementation PhotoFlowModel
- (id)init
{
    self = [super init];
    if(self)
    {
        
    }
    return self;
}

- (void)setForPhotoPicker:(BOOL)forPhotoPicker
{
    _forPhotoPicker = forPhotoPicker;
    PhotoItem *holdItem = [[PhotoItem alloc] init];
    [holdItem setWidth:1];
    [holdItem setHeight:1];
    [self.modelItemArray addObject:holdItem];
}

- (BOOL)hasMoreData
{
    return self.total + (self.forPhotoPicker ? 1 : 0) > self.modelItemArray.count;
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
