//
//  MySendNotificationModel.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/8/15.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "MySendNotificationModel.h"

@implementation MySendNotificationModel
- (BOOL)hasMoreData{
    return self.total > self.modelItemArray.count;
}

- (BOOL)parseData:(TNDataWrapper *)data type:(REQUEST_TYPE)type{
    self.total = [data getIntegerForKey:@"total"];
    if(type == REQUEST_REFRESH){
        [self.modelItemArray removeAllObjects];
    }
    TNDataWrapper *listWrapper = [data getDataWrapperForKey:@"list"];
    [self.modelItemArray addObjectsFromArray:[NotificationItem nh_modelArrayWithJson:listWrapper.data]];
    
    return YES;
}
@end
