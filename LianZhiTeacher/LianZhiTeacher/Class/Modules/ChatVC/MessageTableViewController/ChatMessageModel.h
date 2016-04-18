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
@property (nonatomic, copy)NSString *targetUser;
@property (nonatomic, assign)NSInteger getMoreCount;
@property (nonatomic,assign)BOOL more;
@property (nonatomic, copy)NSString *oldId;
@property (nonatomic, copy)NSString *latestId;
@property (nonatomic, assign)BOOL hasNew;
@property (nonatomic, assign)BOOL soundOff;
@property (nonatomic, assign)BOOL getHistory;
@property (nonatomic, assign)BOOL needScrollBottom;
@property (nonatomic, assign)NSInteger numOfNew;
- (BOOL)canInsert:(MessageItem *)messageItem;
@end
