//
//  ResponseItem.h
//  LianZhiParent
//
//  Created by jslsxu on 15/8/30.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "TNModelItem.h"

@interface CommentItem : TNModelItem
@property (nonatomic, copy)NSString *content;
@property (nonatomic, copy)NSString *toUser;
@property (nonatomic, copy)NSString *commentId;
@property (nonatomic, copy)NSString *ctime;

@end

@interface ResponseItem : TNModelItem
@property (nonatomic, assign)BOOL isTmp;
@property (nonatomic, strong)UserInfo *sendUser;
@property (nonatomic, strong)CommentItem *commentItem;
@end

@interface ResponseModel : TNModelItem
@property (nonatomic, strong)NSMutableArray* praiseArray;      // 点赞的数组
@property (nonatomic, strong)NSMutableArray* responseArray;    // 回复的数组

- (void)addResponse:(ResponseItem *)newResponse;
- (void)addPraiseUser:(UserInfo *)praiseUser;
- (void)removePraise;
- (void)removeResponse:(ResponseItem *)delResponse;
- (BOOL)praised;
@end