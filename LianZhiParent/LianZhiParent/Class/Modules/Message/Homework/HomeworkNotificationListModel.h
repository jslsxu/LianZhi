//
//  HomeworkNotificationListModel.h
//  LianZhiParent
//
//  Created by qingxu zhou on 16/10/24.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "TNListModel.h"
#import "HomeworkNotificationItem.h"
@interface HomeworkNotificationListModel : TNListModel
@property (nonatomic, assign)BOOL hasMore;
@property (nonatomic, copy)NSString *minID;
@end
