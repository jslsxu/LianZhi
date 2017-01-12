//
//  ClassAttendanceListModel.h
//  LianZhiTeacher
//
//  Created by jslsxu on 16/12/18.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "TNListModel.h"
#import "FilterView.h"
@interface AllInfo : TNBaseObject
@property (nonatomic, assign)NSInteger total;
@property (nonatomic, assign)NSInteger attendance;
@property (nonatomic, assign)NSInteger absence;
@property (nonatomic, assign)NSInteger class_total;
@property (nonatomic, copy)NSString* attendance_rate;
@property (nonatomic, copy)NSString* absence_rate;
@property (nonatomic, assign)NSInteger no_submit;
@end

@interface ClassAttendanceItem : TNModelItem
@property (nonatomic, assign)BOOL submit_leave;
@property (nonatomic, assign)NSInteger total;
@property (nonatomic, assign)NSInteger attendance;
@property (nonatomic, assign)NSInteger absence;
@property (nonatomic, assign)NSInteger normal_num;
@property (nonatomic, assign)NSInteger late_num;
@property (nonatomic, assign)NSInteger leave_num;
@property (nonatomic, assign)NSInteger noleave_num;
@property (nonatomic, assign)BOOL is_admin;
@property (nonatomic, strong)ClassInfo* class_info;
@property (nonatomic, copy)NSString* schoolID;
@property (nonatomic, copy)NSString* teacherID;
@property (nonatomic, copy)NSString* mobile;
@property (nonatomic, copy)NSString* teacherName;
@property (nonatomic, copy)NSString* grade_id;
@property (nonatomic, copy)NSString* grade_name;
@end

@interface AppH5 : TNBaseObject
@property (nonatomic, assign)BOOL flg;
@property (nonatomic, copy)NSString* url;
@end

@interface ClassAttendanceListModel : TNListModel
@property (nonatomic, strong)AllInfo* all;
@property (nonatomic, strong)AppH5* appH5;
@property (nonatomic, assign)AttendanceClassFilterType filterType;
- (void)clear;
@end
