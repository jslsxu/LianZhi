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

typedef NS_ENUM(NSInteger, NoteType){
    NoteTypeDaka = 0,
    NoteTypeLeave = 1,
    NoteTypeTeacherEdit = 2,
};

@interface AttendanceNoteItem : TNBaseObject
@property (nonatomic, copy)NSString* ctime;
@property (nonatomic, copy)NSString* recode;
@property (nonatomic, assign)NoteType ctype;
@property (nonatomic, assign)BOOL unread;           //请假记录是未读
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
@property (nonatomic, copy)NSString* edit_mark;
- (BOOL)edited;
- (NSString*)editComment;
- (BOOL)normalAttendance;
- (BOOL)editNormalAttenance;
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
@property (nonatomic, assign)BOOL submit_leave;
@property (nonatomic, assign)NSInteger sortIndex;
@property (nonatomic, assign)BOOL attendaceEdit;
@property (nonatomic, assign)NSInteger absenceIndex;
- (void)sortModelList:(NSInteger)sortIndex;
- (NSDictionary *)modelDictionary;
- (NSString *)titleForSection:(NSInteger)section;
- (NSArray *)titleArray;
- (NSInteger)attendanceNum;
- (NSInteger)absenceNum;
@end
