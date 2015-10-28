//
//  ResponseItem.m
//  LianZhiParent
//
//  Created by jslsxu on 15/8/30.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "ResponseItem.h"

@implementation CommentItem

- (id)init
{
    self = [super init];
    if(self)
    {
        NSInteger timeInterval = [[NSDate date] timeIntervalSince1970];
        self.commentId = [NSString stringWithFormat:@"%ld_%ld",(long)timeInterval,(long)arc4random() % 10000];
    }
    return self;
}

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
    self.praiseArray = [NSMutableArray array];
    TNDataWrapper *praiseWrapper = [dataWrapper getDataWrapperForKey:@"favor_list"];
    if(praiseWrapper.count > 0)
    {
        for (NSInteger i = 0; i < praiseWrapper.count; i++)
        {
            TNDataWrapper *praiseUserWrapper = [praiseWrapper getDataWrapperForIndex:i];
            UserInfo *userInfo = [[UserInfo alloc] init];
            [userInfo parseData:praiseUserWrapper];
            [self.praiseArray addObject:userInfo];
        }
    }
    
    self.responseArray = [NSMutableArray array];
    TNDataWrapper *responseWrapper = [dataWrapper getDataWrapperForKey:@"comment_list"];
    if(responseWrapper.count > 0)
    {
        for (NSInteger i = 0; i < responseWrapper.count; i++)
        {
            TNDataWrapper *responseItemWrapper = [responseWrapper getDataWrapperForIndex:i];
            ResponseItem *responseItem = [[ResponseItem alloc] init];
            [responseItem parseData:responseItemWrapper];
            [self.responseArray addObject:responseItem];
        }
    }
    
}

- (void)addResponse:(ResponseItem *)newResponse
{
    [self.responseArray insertObject:newResponse atIndex:0];
}

- (void)addPraiseUser:(UserInfo *)praiseUser
{
    BOOL contains = NO;
    for (UserInfo *userInfo in self.praiseArray)
    {
        if([userInfo.uid isEqualToString:praiseUser.uid])
            contains = YES;
    }
    if(!contains)
        [self.praiseArray insertObject:praiseUser atIndex:0];
}

- (void)removePraise
{
    NSMutableArray *delArray = [NSMutableArray array];
    for (UserInfo *userInfo in self.praiseArray)
    {
        if([userInfo.uid isEqualToString:[UserCenter sharedInstance].userInfo.uid])
        {
            [delArray addObject:userInfo];
        }
    }
    [self.praiseArray removeObjectsInArray:delArray];
}

- (void)removeResponse:(ResponseItem *)delResponse
{
    if([self.responseArray containsObject:delResponse])
        [self.responseArray removeObject:delResponse];
}

- (BOOL)praised
{
    for (UserInfo *userInfo in self.praiseArray)
    {
        if([[UserCenter sharedInstance].userInfo.uid isEqualToString:userInfo.uid])
            return YES;
    }
    return NO;
}

@end