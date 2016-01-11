//
//  MyAttendanceItem.h
//  LianZhiTeacher
//
//  Created by jslsxu on 15/10/7.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "TNModelItem.h"

@interface MyAttendanceItem : TNModelItem
@property (nonatomic, assign)NSInteger timeStamp;
@property (nonatomic, copy)NSString *startTime;
@property (nonatomic, copy)NSString *startRegion;
@property (nonatomic, copy)NSString *endTime;
@property (nonatomic, copy)NSString *endRegion;
@end
