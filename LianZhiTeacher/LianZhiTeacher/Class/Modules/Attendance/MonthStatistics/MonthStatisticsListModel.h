//
//  MonthStatisticsListModel.h
//  LianZhiTeacher
//
//  Created by jslsxu on 16/12/23.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "TNListModel.h"

@interface MonthStatisticsItem : TNModelItem
@property (nonatomic, assign)NSInteger row;
@property (nonatomic, assign)NSInteger attendance;
@property (nonatomic, assign)NSInteger absence;
@property (nonatomic, strong)StudentInfo* child_info;
@end

@interface MonthStatisticsListModel : TNListModel
@property(nonatomic, assign)NSInteger class_attendance;
@property (nonatomic, assign)NSInteger sortIndex;

- (NSString *)titleForSection:(NSInteger)section;
- (NSArray *)titleArray;
@end
