//
//  ResponseItem.m
//  LianZhiParent
//
//  Created by jslsxu on 15/8/30.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "ResponseItem.h"

@implementation ResponseItem
- (void)parseData:(TNDataWrapper *)dataWrapper
{
    UserInfo *sendUser = [[UserInfo alloc] init];
    self.sendUser = sendUser;
    
//    UserInfo *targetUser = [[UserInfo alloc] init];
//    self.targetUser = targetUser;
    
    self.content = @"照的相片不错，“简洁”并不等于一丝不挂，如果是去了红红绿绿的万千时装，则大千";
}
@end

@implementation ResponseModel

- (void)parseData:(TNDataWrapper *)dataWrapper
{
    //test
    NSMutableArray *praiseArray = [NSMutableArray array];
    for (NSInteger i = 0; i < (arc4random() % 4 + 5); i++)
    {
        [praiseArray addObject:[UserCenter sharedInstance].userInfo.avatar];
    }
    self.praiseArray = praiseArray;
    
    NSString *sourceStr = @"照的相片不错，“简洁”并不等于一丝不挂，如果是去了红红绿绿的万千时装，则大千";
    NSMutableArray *responseArray = [NSMutableArray array];
    for (NSInteger i = 0; i < 4; i ++)
    {
        UserInfo *sendUser = [UserCenter sharedInstance].userInfo;
        UserInfo *targetUser = [UserCenter sharedInstance].userInfo;
        ResponseItem *responseItem = [[ResponseItem alloc] init];
        responseItem.sendUser = sendUser;
        responseItem.targetUser = targetUser;
        responseItem.content = [sourceStr substringToIndex:arc4random() % sourceStr.length];
        [responseArray addObject:responseItem];
    }
    self.responseArray = responseArray;
}

@end