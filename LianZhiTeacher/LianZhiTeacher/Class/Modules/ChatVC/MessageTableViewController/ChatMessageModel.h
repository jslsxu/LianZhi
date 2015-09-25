//
//  ChatMessageModel.h
//  LianZhiParent
//
//  Created by jslsxu on 15/9/20.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "TNListModel.h"
#import "MessageItem.h"
@interface ChatMessageModel : TNListModel
@property (nonatomic,assign)BOOL more;
@property (nonatomic, copy)NSString *oldId;
@property (nonatomic, copy)NSString *latestId;
@property (nonatomic, assign)BOOL hasNew;
- (BOOL)canInsert:(MessageItem *)messageItem;
@end
