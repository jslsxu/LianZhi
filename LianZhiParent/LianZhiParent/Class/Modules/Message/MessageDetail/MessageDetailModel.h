//
//  MessageDetailModel.h
//  LianZhiParent
//
//  Created by jslsxu on 14/12/24.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "TNListModel.h"
#import "MessageGroupListModel.h"
#import "MessageDetailItem.h"
@interface MessageDetailModel : TNListModel
@property (nonatomic, strong)MessageFromInfo *fromInfo;
@property (nonatomic, assign)BOOL hasMore;
@property (nonatomic, copy)NSString *minID;
@end
