//
//  ClassAttendanceListModel.m
//  LianZhiTeacher
//
//  Created by jslsxu on 16/12/18.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "ClassAttendanceListModel.h"

@implementation ClassAttendanceListModel
- (instancetype)init{
    self = [super init];
    if(self){
        for (NSInteger i = 0; i < 10; i++) {
            [self.modelItemArray addObject:@""];
        }
    }
    return self;
}
@end
