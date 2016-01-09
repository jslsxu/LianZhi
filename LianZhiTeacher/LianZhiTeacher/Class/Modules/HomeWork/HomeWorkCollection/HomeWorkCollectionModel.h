//
//  HomeWorkCollectionModel.h
//  LianZhiTeacher
//
//  Created by jslsxu on 15/11/27.
//  Copyright © 2015年 jslsxu. All rights reserved.
//

#import "TNListModel.h"
#import "HomeWorkHistoryModel.h"
@interface HomeWorkCollectionModel : TNListModel
@property (nonatomic, assign)BOOL has;
@property (nonatomic, copy)NSString *maxID;
@end
