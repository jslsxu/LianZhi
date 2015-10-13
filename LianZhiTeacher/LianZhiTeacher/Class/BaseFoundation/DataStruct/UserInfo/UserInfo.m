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
    self.activited = [dataWrapper getBoolForKey:@"actived"];
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
    [dictionary setValue:kStringFromValue(self.activited) forKey:@"actived"];
    return dictionary;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super init])
    {
        self.uid = [aDecoder decodeObjectForKey:@"id"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.title = [aDecoder decodeObjectForKey:@"title"];
        self.nickName = [aDecoder decodeObjectForKey:@"nick"];
        self.gender = [aDecoder decodeIntegerForKey:@"sex"];
        self.mobile = [aDecoder decodeObjectForKey:@"mobile"];
        self.avatar = [aDecoder decodeObjectForKey:@"head"];
        self.constellation = [aDecoder decodeObjectForKey:@"constellation"];
        self.email = [aDecoder decodeObjectForKey:@"email"];
        self.birthDay = [aDecoder decodeObjectForKey:@"birthday"];
        self.activited = [aDecoder decodeBoolForKey:@"actived"];
        
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.uid forKey:@"id"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.nickName forKey:@"nick"];
    [aCoder encodeInteger:self.gender forKey:@"sex"];
    [aCoder encodeObject:self.mobile forKey:@"mobile"];
    [aCoder encodeObject:self.avatar forKey:@"head"];
    [aCoder encodeObject:self.constellation forKey:@"constellation"];
    [aCoder encodeObject:self.email forKey:@"email"];
    [aCoder encodeObject:self.birthDay forKey:@"birthday"];
    [aCoder encodeBool:self.activited forKey:@"actived"];
}

@end
