//
//  ClassZoneModel.h
//  LianZhiParent
//
//  Created by jslsxu on 14/12/23.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "TNListModel.h"
#import "ResponseItem.h"
@interface ClassZoneItem : TNModelItem
@property (nonatomic, strong)UserInfo *userInfo;
@property (nonatomic, copy)NSString *itemID;
@property (nonatomic, copy)NSString *content;
@property (nonatomic, strong)NSArray *photos;
@property (nonatomic, strong)AudioItem *audioItem;
@property (nonatomic, copy)NSString *time;
@property (nonatomic, copy)NSString *formatTime;
@property (nonatomic, assign)BOOL canEdit;
@property (nonatomic, strong)NSArray* praiseArray;      // 点赞的数组
@property (nonatomic, strong)NSArray* responseArray;    // 回复的数组
@end

@interface ClassZoneModel : TNListModel
@property (nonatomic, assign)BOOL hasMore;
@property (nonatomic, copy)NSString *newsPaper;
@property (nonatomic, copy)NSString *minID;
@end
