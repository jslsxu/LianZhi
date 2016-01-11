//
//  MyAttendanceModel.h
//  LianZhiTeacher
//
//  Created by jslsxu on 15/10/7.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "TNListModel.h"
#import "MyAttendanceItem.h"
@interface MyAttendanceModel : TNListModel
@property (nonatomic, strong)MyAttendanceItem *todayItem;
@end
