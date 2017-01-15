//
//  StudentsAttendanceListModel.h
//  LianZhiTeacher
//
//  Created by jslsxu on 16/12/23.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "TNListModel.h"

typedef NS_ENUM(NSInteger, AttendanceStatus){
    AttendanceStatusNormal = 0,
    AttendanceStatusLate = 1,
    AttendanceStatusLeave = 2,
    AttendanceStatusAbsence = 3,
};

@interface AttendanceNoteItem : TNBaseObject
@property (nonatomic, copy)NSString* ctime;
@property (nonatomic, copy)NSString* recode;
@end

@interface StudentAttendanceItem : TNModelItem
@property (nonatomic, strong)StudentInfo* child_info;
@property (nonatomic, assign)AttendanceStatus status;
@property (nonatomic, strong)NSArray* recode;
@property (nonatomic, copy)NSString* action;
@property (nonatomic, copy)NSString* aid;
@property (nonatomic, copy)NSString* school_id;
@property (nonatomic, copy)NSString* class_id;
@property (nonatomic, copy)NSString* cdate;
@property (nonatomic, copy)NSString* mark_time;
@property (nonatomic, copy)NSString* mark_info;
@property (nonatomic, copy)NSString* start_leave_time;
@property (nonatomic, copy)NSString* end_leave_time;
@property (nonatomic, assign)BOOL teacher_edit;
@property (nonatomic, copy)NSString* puid;
@property (nonatomic, copy)NSString* tuid;
@property (nonatomic, assign)BOOL absenceHighlighted;

@property (nonatomic, assign)AttendanceStatus newStatus;

- (BOOL)edited;
- (NSString*)editComment;
- (BOOL)normalAttendance;
- (NSDictionary *)attedanceInfo;
@end

@interface ClassAttendanceInfo : TNModelItem
@property (nonatomic, assign)NSInteger total;
@property (nonatomic, assign)NSInteger attendance;
@property (nonatomic, assign)NSInteger absence;
@property (nonatomic, copy)NSString* rate;
@end
@interface StudentsAttendanceListModel : TNListModel
@property (nonatomic, strong)ClassAttendanceInfo* info;
@property (nonatomic, assign)NSInteger sortIndex;
@property (nonatomic, assign)BOOL attendaceEdit;
@property (nonatomic, assign)NSInteger absenceIndex;
- (NSDictionary *)modelDictionary;
- (NSString *)titleForSection:(NSInteger)section;
- (NSArray *)titleArray;
- (NSInteger)attendanceNum;
- (NSInteger)absenceNum;
@end
