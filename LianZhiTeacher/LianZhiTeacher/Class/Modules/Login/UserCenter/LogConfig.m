//
//  LogConfig.m
//  LianZhiTeacher
//
//  Created by jslsxu on 15/2/5.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "LogConfig.h"

@implementation LogConfig
- (void)parseData:(TNDataWrapper *)dataWrapper
{
    self.dicoveryUrl = [dataWrapper getStringForKey:@"find_url"];
    self.introUrl = [dataWrapper getStringForKey:@"intro_url"];
    self.aboutUrl = [dataWrapper getStringForKey:@"about_url"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if(self)
    {
        self.dicoveryUrl = [aDecoder decodeObjectForKey:@"find_url"];
        self.introUrl = [aDecoder decodeObjectForKey:@"intro_url"];
        self.aboutUrl = [aDecoder decodeObjectForKey:@"about_url"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.dicoveryUrl forKey:@"find_url"];
    [aCoder encodeObject:self.introUrl forKey:@"intro_url"];
    [aCoder encodeObject:self.aboutUrl forKey:@"about_url"];
}
@end
