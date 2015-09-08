//
//  ResponseItem.h
//  LianZhiParent
//
//  Created by jslsxu on 15/8/30.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "TNModelItem.h"

@interface ResponseItem : TNModelItem
@property (nonatomic, strong)UserInfo *sendUser;
@property (nonatomic, strong)UserInfo *targetUser;
@property (nonatomic, copy)NSString *content;
@end

@interface ResponseModel : TNModelItem
@property (nonatomic, strong)NSArray* praiseArray;      // 点赞的数组
@property (nonatomic, strong)NSArray* responseArray;    // 回复的数组

@end