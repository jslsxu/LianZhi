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
    self.helpUrl = [dataWrapper getStringForKey:@"help_url"];
    self.faqUrl = [dataWrapper getStringForKey:@"faq_url"];
}

@end
