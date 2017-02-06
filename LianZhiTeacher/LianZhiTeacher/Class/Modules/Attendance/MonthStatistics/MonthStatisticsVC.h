//
//  MonthStatisticsVC.h
//  LianZhiTeacher
//
//  Created by jslsxu on 16/12/22.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"

@interface MonthStatisticsVC : TNBaseTableViewController
@property (nonatomic, strong)NSArray* classArray;
@property (nonatomic, strong)ClassInfo* classInfo;
@property (nonatomic, strong)NSDate* date;
@end
