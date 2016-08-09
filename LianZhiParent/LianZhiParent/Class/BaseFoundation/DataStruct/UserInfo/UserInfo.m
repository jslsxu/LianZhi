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
    self.nickName = [dataWrapper getStringForKey:@"nick"];
    self.gender = [dataWrapper getIntegerForKey:@"sex"];
    self.mobile = [dataWrapper getStringForKey:@"mobile"];
    self.avatar = [dataWrapper getStringForKey:@"head"];
    self.constellation = [dataWrapper getStringForKey:@"constellation"];
    self.email = [dataWrapper getStringForKey:@"email"];
    self.birthDay = [dataWrapper getStringForKey:@"birthday"];
    self.actived = [dataWrapper getBoolForKey:@"actived"];
    self.blid = [dataWrapper getStringForKey:@"blid"];
    self.shortIndex = [dataWrapper getStringForKey:@"first_letter"];
}

- (NSDictionary *)toDictionary
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setValue:self.uid forKey:@"id"];
    [dictionary setValue:self.name forKey:@"name"];
    [dictionary setValue:self.title forKey:@"title"];
    [dictionary setValue:self.nickName forKey:@"nick"];
    [dictionary setValue:kStringFromValue(self.gender) forKey:@"sex"];
    [dictionary setValue:self.mobile forKey:@"mobile"];
    [dictionary setValue:self.avatar forKey:@"head"];
    [dictionary setValue:self.constellation forKey:@"constellation"];
    [dictionary setValue:self.email forKey:@"email"];
    [dictionary setValue:self.birthDay forKey:@"birthday"];
    [dictionary setValue:kStringFromValue(self.actived) forKey:@"actived"];
    [dictionary setValue:self.shortIndex forKey:@"first_letter"];
    return dictionary;
}


@end
