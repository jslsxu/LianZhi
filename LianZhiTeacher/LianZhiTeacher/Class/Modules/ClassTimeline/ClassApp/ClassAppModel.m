//
//  ClassAppModel.m
//  LianZhiParent
//
//  Created by jslsxu on 15/1/2.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "ClassAppModel.h"

@implementation ClassAppItem

- (void)parseData:(TNDataWrapper *)dataWrapper
{
    self.appID = [dataWrapper getStringForKey:@"id"];
    self.appName = [dataWrapper getStringForKey:@"name"];
    self.imageUrl = [dataWrapper getStringForKey:@"icon"];
    self.actionUrl = [dataWrapper getStringForKey:@"url"];
}
@end

@implementation ClassAppModel

- (BOOL)parseData:(TNDataWrapper *)data type:(REQUEST_TYPE)type
{
    BOOL parse = [super parseData:data type:type];
    
    if(type == REQUEST_REFRESH)
        [self.modelItemArray removeAllObjects];
    TNDataWrapper *listWrapper = [data getDataWrapperForKey:@"list"];
    if(listWrapper.count > 0)
    {
        for (NSInteger i = 0; i < listWrapper.count; i++) {
            ClassAppItem *item = [[ClassAppItem alloc] init];
            TNDataWrapper *itemWrapper = [listWrapper getDataWrapperForIndex:i];
            [item parseData:itemWrapper];
            [self.modelItemArray addObject:item];
        }
    }
    return parse;
}
@end
