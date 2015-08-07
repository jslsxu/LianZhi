//
//  ClassZoneModel.h
//  LianZhiParent
//
//  Created by jslsxu on 14/12/23.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "TNListModel.h"

@interface ClassZoneItem : TNModelItem
@property (nonatomic, strong)UserInfo *userInfo;
@property (nonatomic, copy)NSString *itemID;
@property (nonatomic, copy)NSString *content;
@property (nonatomic, strong)NSArray *photos;
@property (nonatomic, strong)AudioItem *audioItem;
@property (nonatomic, copy)NSString *time;
@property (nonatomic, copy)NSString *formatTime;
@property (nonatomic, assign)BOOL canEdit;
@end

@interface ClassZoneModel : TNListModel
@property (nonatomic, assign)BOOL hasMore;
@property (nonatomic, copy)NSString *newsPaper;
@property (nonatomic, copy)NSString *minID;
@end
