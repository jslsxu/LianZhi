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
@property (nonatomic, copy)NSString *position;
@property (nonatomic, assign)CGFloat longitude;
@property (nonatomic, assign)CGFloat latitude;
@property (nonatomic, copy)NSString *itemID;
@property (nonatomic, copy)NSString *content;
@property (nonatomic, strong)NSArray *photos;
@property (nonatomic, strong)AudioItem *audioItem;
@property (nonatomic, copy)NSString *time;
@property (nonatomic, copy)NSString *formatTime;
@property (nonatomic, assign)BOOL canEdit;
@property (nonatomic, strong)ResponseModel *responseModel;
@end

@interface ClassZoneModel : TNListModel
@property (nonatomic, assign)BOOL hasMore;
@property (nonatomic, copy)NSString *newsPaper;
@property (nonatomic, copy)NSString *minID;
@end
