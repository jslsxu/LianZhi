//
//  MessageDetailModel.h
//  LianZhiParent
//
//  Created by jslsxu on 14/12/24.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "TNListModel.h"
#import "MessageGroupListModel.h"
@interface MessageDetailItem : TNModelItem
@property (nonatomic, strong)MessageFromInfo *fromInfo;
@property (nonatomic, copy)NSString *msgID;
@property (nonatomic, strong)UserInfo *author;
@property (nonatomic, copy)NSString *content;
@property (nonatomic, strong)AudioItem *audioItem;
@property (nonatomic, strong)NSArray*   pictureArray;
@property (nonatomic, copy)NSString *time;
@property (nonatomic, copy)NSString *timeStr;
@end

@interface MessageDetailModel : TNListModel
@property (nonatomic, strong)MessageFromInfo *fromInfo;
@property (nonatomic, assign)BOOL hasMore;
@property (nonatomic, copy)NSString *minID;
@end
