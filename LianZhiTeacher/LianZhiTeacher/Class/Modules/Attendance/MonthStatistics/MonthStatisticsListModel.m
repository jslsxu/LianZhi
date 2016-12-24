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
- (instancetype)init{
    self = [super init];
    if(self){
        for (NSInteger i = 0; i < 10; i ++) {
            MonthStatisticsItem *item = [[MonthStatisticsItem alloc] init];
            [item setRow:i];
            [self.modelItemArray addObject:item];
        }
    }
    return self;
}
@end
