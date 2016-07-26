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
    self.uid = [dataWrapper getStringForKey:@"id"];
    self.name = [dataWrapper getStringForKey:@"name"];
    self.label = [dataWrapper getStringForKey:@"label"];
    self.title = [dataWrapper getStringForKey:@"title"];
    self.nick = [dataWrapper getStringForKey:@"nick"];
    self.sex = [dataWrapper getIntegerForKey:@"sex"];
    self.mobile = [dataWrapper getStringForKey:@"mobile"];
    self.avatar = [dataWrapper getStringForKey:@"head"];
    self.constellation = [dataWrapper getStringForKey:@"constellation"];
    self.email = [dataWrapper getStringForKey:@"email"];
    self.birthday = [dataWrapper getStringForKey:@"birthday"];
    self.actived = [dataWrapper getBoolForKey:@"actived"];
    self.first_letter = [dataWrapper getStringForKey:@"first_letter"];
}
+ (NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    return @{@"uid" : @"id",
             @"avatar":@"head"};
}

@end
