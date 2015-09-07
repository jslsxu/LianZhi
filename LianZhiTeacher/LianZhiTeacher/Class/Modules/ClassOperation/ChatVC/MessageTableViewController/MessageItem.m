//
//  MessageItem.m
//  MFWIOS
//
//  Created by jslsxu on 9/24/13.
//  Copyright (c) 2013 mafengwo. All rights reserved.
//

#import "MessageItem.h"

@implementation MessageItem

- (void)parseData:(TNDataWrapper *)dataWrapper
{
    self.messageType = [dataWrapper getBoolForKey:@"is_from_myself"];
    self.content = [dataWrapper getStringForKey:@"content"];
    self.ctime = [dataWrapper getStringForKey:@"time"];
    self.messageState = MessageStateNormal;
    TNDataWrapper *userDataWrapper = [dataWrapper getDataWrapperForKey:@"user"];
    UserInfo *userInfo = [[UserInfo alloc] init];
    [userInfo parseData:userDataWrapper];
    self.userInfo = userInfo;
}


@end
