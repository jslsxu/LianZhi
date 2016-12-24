//
//  StudentsAttendanceListModel.h
//  LianZhiTeacher
//
//  Created by jslsxu on 16/12/23.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "TNListModel.h"

@interface AttendanceNoteItem : TNBaseObject
@property (nonatomic, copy)NSString* time;
@property (nonatomic, copy)NSString* note;
@end

@interface StudentAttendanceItem : TNModelItem
@property (nonatomic, strong)StudentInfo* studentInfo;
@property (nonatomic, assign)BOOL attendance;
@property (nonatomic, strong)NSArray* notes;
@property (nonatomic, copy)NSString* comment;
@end

@interface StudentsAttendanceListModel : TNListModel

@end
