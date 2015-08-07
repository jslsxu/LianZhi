//
//  VacationHistoryModel.h
//  LianZhiParent
//
//  Created by jslsxu on 15/5/27.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "TNListModel.h"

@interface VacationHistoryItem : TNModelItem
@property (nonatomic, strong)UserInfo *userInfo;
@property (nonatomic, assign)BOOL isNew;
@property (nonatomic, copy)NSString *duration;
@property (nonatomic, copy)NSString *timeStr;
@property (nonatomic, copy)NSString *stateStr;
@end

@interface VacationHistoryModel : TNListModel

@end
