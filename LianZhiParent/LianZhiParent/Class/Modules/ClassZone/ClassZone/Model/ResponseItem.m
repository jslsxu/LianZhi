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
