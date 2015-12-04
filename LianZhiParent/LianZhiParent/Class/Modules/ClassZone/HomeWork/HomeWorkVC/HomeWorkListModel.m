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

- (id)init
{
    self = [super init];
    if(self)
    {
        for (NSInteger i = 0; i < 4; i++)
        {
            
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

@end
