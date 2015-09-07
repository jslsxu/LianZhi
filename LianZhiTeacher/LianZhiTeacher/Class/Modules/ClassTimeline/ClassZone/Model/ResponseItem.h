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
