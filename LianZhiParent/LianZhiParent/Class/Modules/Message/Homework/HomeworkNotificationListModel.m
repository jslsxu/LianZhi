//
//  HomeworkNotificationListModel.m
//  LianZhiParent
//
//  Created by qingxu zhou on 16/10/24.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "HomeworkNotificationListModel.h"

@implementation HomeworkNotificationListModel
- (BOOL)hasMoreData
{
    return self.hasMore;
}

- (NSString *)minID
{
    HomeworkNotificationItem *lastItem = [self.modelItemArray lastObject];
    return lastItem.msgId;
}

- (BOOL)parseData:(TNDataWrapper *)data type:(REQUEST_TYPE)type
{
    BOOL parse = [super parseData:data type:type];
    
    if(type == REQUEST_REFRESH)
        [self.modelItemArray removeAllObjects];
    self.hasMore = [data getBoolForKey:@"has_next"];
    TNDataWrapper *listWrapper = [data getDataWrapperForKey:@"list"];
    [self.modelItemArray addObjectsFromArray:[HomeworkNotificationItem nh_modelArrayWithJson:listWrapper.data]];
    
    return parse;
}
@end
