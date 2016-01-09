//
//  HomeWorkHistoryModel.h
//  LianZhiTeacher
//
//  Created by jslsxu on 15/10/31.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "TNListModel.h"
#import "HomeworkItem.h"

@interface HomeWorkHistoryModel : TNListModel
@property (nonatomic, assign)BOOL has;
@property (nonatomic, copy)NSString *maxID;
@end
