//
//  UserInfo.m
//  LianZhiParent
//
//  Created by jslsxu on 15/1/10.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo
- (void)parseData:(TNDataWrapper *)dataWrapper
{
    [self modelSetWithJSON:dataWrapper.data];
}

- (NSString *)namePinyin{
    if(!self.pinyin){
        self.pinyin = [self.name transformToPinyin];
    }
    return self.pinyin;
}
+ (NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    return @{@"uid" : @"id",
             @"avatar":@[@"head", @"avatar"]
             };
}

//+ (nullable NSArray<NSString *> *)modelPropertyBlacklist{
//    return @[@"selected"];
//}

@end
