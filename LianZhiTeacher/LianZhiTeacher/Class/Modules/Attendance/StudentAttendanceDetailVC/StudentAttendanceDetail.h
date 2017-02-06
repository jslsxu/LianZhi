//
//  StudentAttendanceDetail.h
//  LianZhiTeacher
//
//  Created by jslsxu on 17/1/12.
//  Copyright © 2017年 jslsxu. All rights reserved.
//

#import "TNBaseObject.h"
#import "StudentsAttendanceListModel.h"
@interface StudentAttendanceDetailInfo : TNBaseObject
@property (nonatomic, copy)NSString* attendance_rate;
@property (nonatomic, copy)NSString* absence_rate;
@property (nonatomic, assign)NSInteger attendance;
@property (nonatomic, assign)NSInteger absence;
@end

@interface StudentAttendanceDetail : TNBaseObject
@property (nonatomic, strong)NSArray* recode;
@property (nonatomic, strong)StudentAttendanceDetailInfo* info;
@property (nonatomic, strong)StudentInfo* studentInfo;
@property (nonatomic, strong)NSArray* month_leave;
- (BOOL)isAttendanceValidate;
@end
