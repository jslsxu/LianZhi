//
//  MonthStatisticsListModel.m
//  LianZhiTeacher
//
//  Created by jslsxu on 16/12/23.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "MonthStatisticsListModel.h"

@implementation MonthStatisticsItem

@end

@implementation MonthStatisticsListModel

- (BOOL)parseData:(TNDataWrapper *)data type:(REQUEST_TYPE)type{
    self.class_attendance = [data getIntegerForKey:@"class_attendance"];
    TNDataWrapper* listWrapper = [data getDataWrapperForKey:@"items"];
    if(type == REQUEST_REFRESH){
        [self.modelItemArray removeAllObjects];
    }
    NSArray* items = [MonthStatisticsItem nh_modelArrayWithJson:listWrapper.data];
    [self.modelItemArray addObjectsFromArray:items];
    return YES;
}
@end
