//
//  MessageGroupListModel.m
//  LianZhiParent
//
//  Created by jslsxu on 14/12/23.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "MessageGroupListModel.h"

#define kAlertSettingList           @"AlertSettingList"

@implementation MessageFromInfo
- (void)parseData:(TNDataWrapper *)dataWrapper
{
    self.uid = [dataWrapper getStringForKey:@"id"];
    self.logoUrl = [dataWrapper getStringForKey:@"logo"];
    self.name = [dataWrapper getStringForKey:@"name"];
    self.type = [dataWrapper getIntegerForKey:@"type"];
    self.label = [dataWrapper getStringForKey:@"label"];
    self.from_obj_id = [dataWrapper getStringForKey:@"from_obj_id"];
}

- (BOOL)isNotification
{
    if(self.type == MessageFromTypeFromClass || self.type == MessageFromTypeFromParents||self.type == MessageFromTypeFromTeacher)
        return NO;
    return YES;
}
@end

@implementation MessageGroupItem
- (void)parseData:(TNDataWrapper *)dataWrapper
{
    MessageFromInfo *fromInfo = [[MessageFromInfo alloc] init];
    TNDataWrapper *fromInfoWrapper = [dataWrapper getDataWrapperForKey:@"from"];
    [fromInfo parseData:fromInfoWrapper];
    [self setFromInfo:fromInfo];
    
    self.formatTime = [dataWrapper getStringForKey:@"time_str"];
    self.content = [dataWrapper getStringForKey:@"words"];
    self.msgNum = [dataWrapper getIntegerForKey:@"unread"];
//    self.soundOn = ![[DataCenter sharedInstance] checkFromIDSilence:self.fromInfo.uid];
    NSString *sound = [dataWrapper getStringForKey:@"sound"];
    self.soundOn = ([sound isEqualToString:@"open"]);
    
}
@end

@implementation MessageGroupListModel

- (BOOL)hasMoreData
{
    return YES;
}

- (BOOL)parseData:(TNDataWrapper *)data type:(REQUEST_TYPE)type
{
    BOOL parse = [super parseData:data type:type];
    
    if(type == REQUEST_REFRESH)
        [self.modelItemArray removeAllObjects];
    TNDataWrapper *listWrapper = [data getDataWrapperForKey:@"list"];
    if(listWrapper.count > 0)
    {
        BOOL hasNew = NO;//是否有新消息
        for (NSInteger i = 0; i < listWrapper.count; i++)
        {
            MessageGroupItem *item = [[MessageGroupItem alloc] init];
            TNDataWrapper *itemWrapper = [listWrapper getDataWrapperForIndex:i];
            [item parseData:itemWrapper];
            [self.modelItemArray addObject:item];
            
            if(item.msgNum > 0 && item.soundOn)
                hasNew = YES;
        }
    }
    return parse;
}
@end
