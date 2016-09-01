//
//  MessageDetailModel.m
//  LianZhiParent
//
//  Created by jslsxu on 14/12/24.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "MessageDetailModel.h"
@implementation MessageDetailModel

- (BOOL)hasMoreData
{
    return self.hasMore;
}

- (NSString *)minID
{
    MessageDetailItem *lastItem = [self.modelItemArray lastObject];
    return lastItem.msgID;
}

- (BOOL)parseData:(TNDataWrapper *)data type:(REQUEST_TYPE)type
{
    BOOL parse = [super parseData:data type:type];
    
    if(type == REQUEST_REFRESH)
        [self.modelItemArray removeAllObjects];
    self.hasMore = [data getBoolForKey:@"has_next"];
    TNDataWrapper *fromWrapper = [data getDataWrapperForKey:@"from"];
    MessageFromInfo *fromInfo = [[MessageFromInfo alloc] init];
    [fromInfo parseData:fromWrapper];
    self.fromInfo = fromInfo;
    
    TNDataWrapper *listWrapper = [data getDataWrapperForKey:@"list"];
    for (NSInteger i = 0; i < listWrapper.count; i++) {
        MessageDetailItem *item = [[MessageDetailItem alloc] init];
        TNDataWrapper *detailWrapper = [listWrapper getDataWrapperForIndex:i];
        [item parseData:detailWrapper];
        [item setType:fromInfo.type];
        [self.modelItemArray addObject:item];
        if(item.from_user.uid.length == 0){
            UserInfo *fromUser = [[UserInfo alloc] init];
            [fromUser setUid:self.fromInfo.uid];
            [fromUser setAvatar:self.fromInfo.logoUrl];
            [fromUser setName:self.fromInfo.name];
            [item setFrom_user:fromUser];
        }
    }
    return parse;
}
@end
