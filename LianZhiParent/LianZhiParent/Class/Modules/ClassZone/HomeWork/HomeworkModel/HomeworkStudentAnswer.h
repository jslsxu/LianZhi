//
//  HomeworkStudentAnswer.h
//  LianZhiTeacher
//  学生解答
//  Created by qingxu zhou on 16/10/21.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "TNBaseObject.h"
#import "HomeworkTeacherMark.h"

@interface HomeworkStudentAnswer : TNBaseObject
@property (nonatomic, copy)NSString*    answerId;
@property (nonatomic, copy)NSString*    ctime;
@property (nonatomic, strong)NSArray<PhotoItem *>* pics;
@property (nonatomic, strong)HomeworkTeacherMark*   teacherMark;    //老师对作业的批阅
- (BOOL)marked;
@end
