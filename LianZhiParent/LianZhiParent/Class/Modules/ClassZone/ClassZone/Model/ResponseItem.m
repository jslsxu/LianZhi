//
//  ResponseItem.m
//  LianZhiParent
//
//  Created by jslsxu on 15/8/30.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "ResponseItem.h"

@implementation CommentItem

- (void)parseData:(TNDataWrapper *)dataWrapper
{
    self.commentId = [dataWrapper getStringForKey:@"id"];
    self.content = [dataWrapper getStringForKey:@"content"];
    self.toUser = [dataWrapper getStringForKey:@"to_user"];
    self.ctime = [dataWrapper getStringForKey:@"ctime"];
}

@end

@implementation ResponseItem
- (void)parseData:(TNDataWrapper *)dataWrapper
{
    TNDataWrapper *userWrapper = [dataWrapper getDataWrapperForKey:@"user"];
    UserInfo *userInfo = [[UserInfo alloc] init];
    [userInfo parseData:userWrapper];
    self.sendUser = userInfo;
    
    TNDataWrapper *commentWrapper = [dataWrapper getDataWrapperForKey:@"comment"];
    CommentItem *commentItem = [[CommentItem alloc] init];
    [commentItem parseData:commentWrapper];
    self.commentItem = commentItem;
}
@end

@implementation ResponseModel

- (void)parseData:(TNDataWrapper *)dataWrapper
{
    TNDataWrapper *praiseWrapper = [dataWrapper getDataWrapperForKey:@"favor_list"];
    if(praiseWrapper.count > 0)
    {
        NSMutableArray *praiseArray = [NSMutableArray array];
        for (NSInteger i = 0; i < praiseWrapper.count; i++)
        {
            TNDataWrapper *praiseUserWrapper = [praiseWrapper getDataWrapperForIndex:i];
            UserInfo *userInfo = [[UserInfo alloc] init];
            [userInfo parseData:praiseUserWrapper];
            [praiseArray addObject:userInfo];
        }
        self.praiseArray = praiseArray;
    }
    
    TNDataWrapper *responseWrapper = [dataWrapper getDataWrapperForKey:@"comment_list"];
    if(responseWrapper.count > 0)
    {
        NSMutableArray *responseArray = [NSMutableArray array];
        for (NSInteger i = 0; i < responseWrapper.count; i++)
        {
            TNDataWrapper *responseItemWrapper = [responseWrapper getDataWrapperForIndex:i];
            ResponseItem *responseItem = [[ResponseItem alloc] init];
            [responseItem parseData:responseItemWrapper];
            [responseArray addObject:responseItem];
        }
        self.responseArray = responseArray;
    }
    
}

@end