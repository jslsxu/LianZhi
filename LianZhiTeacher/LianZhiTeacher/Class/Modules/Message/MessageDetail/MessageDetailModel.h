//
//  MessageDetailModel.h
//  LianZhiParent
//
//  Created by jslsxu on 14/12/24.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "TNListModel.h"

@interface MessageDetailItem : TNModelItem
@property (nonatomic, copy)NSString *msgID;
@property (nonatomic, copy)NSString *author;
@property (nonatomic, copy)NSString *content;
@property (nonatomic, strong)AudioItem *audioItem;
@property (nonatomic, copy)NSString *time;
@property (nonatomic, copy)NSString *timeStr;
@property (nonatomic, strong)NSArray *photos;
@end

@interface MessageDetailModel : TNListModel
@property (nonatomic, assign)BOOL hasMore;
@property (nonatomic, copy)NSString *minID;
@end
