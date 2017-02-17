//
//  AttendanceDetailResponse.h
//  LianZhiParent
//
//  Created by jslsxu on 17/1/10.
//  Copyright © 2017年 jslsxu. All rights reserved.
//

#import "TNBaseObject.h"

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

@interface AttendanceInfo : TNBaseObject
@property (nonatomic, assign)NSInteger absence;
@property (nonatomic, assign)NSInteger attendance;
@property (nonatomic, copy)NSString* absence_rate;
@property (nonatomic, copy)NSString* attendance_rate;
@end

@interface AttendanceDetailResponse : TNBaseObject
@property (nonatomic, strong)NSArray* recode;
@property (nonatomic, strong)AttendanceInfo *info;
@property (nonatomic, strong)NSArray* month_leave;
@property (nonatomic, strong)NSArray* teacher_submit;
@end
