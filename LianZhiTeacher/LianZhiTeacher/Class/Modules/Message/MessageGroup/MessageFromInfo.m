//
//  MessageFromInfo.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/8/8.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "MessageFromInfo.h"

@implementation MessageFromInfo
- (void)parseData:(TNDataWrapper *)dataWrapper
{
    self.uid = [dataWrapper getStringForKey:@"id"];
    self.logoUrl = [dataWrapper getStringForKey:@"logo"];
    self.name = [dataWrapper getStringForKey:@"name"];
    self.type = [dataWrapper getIntegerForKey:@"type"];
    self.label = [dataWrapper getStringForKey:@"label"];
    self.typeName = [dataWrapper getStringForKey:@"type_name"];
    self.from_obj_id = [dataWrapper getStringForKey:@"from_obj_id"];
    self.mobile = [dataWrapper getStringForKey:@"mobile"];
    self.classID = [dataWrapper getStringForKey:@"class_id"];
    self.childID = [dataWrapper getStringForKey:@"child_id"];
}

- (BOOL)isNotification
{
    if(self.type == ChatTypeClass || self.type == ChatTypeParents||self.type == ChatTypeTeacher || self.type == ChatTypeGroup)
        return NO;
    return YES;
}
@end
