//
//  GiftItem.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/8/18.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "GiftItem.h"

@implementation GiftItem

- (void)parseData:(TNDataWrapper *)dataWrapper
{
    [self modelSetWithJSON:dataWrapper.data];
}

+ (NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    return @{@"giftID" : @"id",
             @"giftName" : @"name"};
}

@end
