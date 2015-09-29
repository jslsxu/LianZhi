//
//  ChildInfo.m
//  LianZhiParent
//
//  Created by jslsxu on 15/1/10.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "SchoolInfo.h"
@implementation SchoolInfo

- (void)parseData:(TNDataWrapper *)dataWrapper
{
    self.schoolID = [dataWrapper getStringForKey:@"id"];
    self.schoolName = [dataWrapper getStringForKey:@"name"];
    self.logoUrl = [dataWrapper getStringForKey:@"logo"];
    self.schoolUrl = [dataWrapper getStringForKey:@"url"];
    
    TNDataWrapper *classDataWrapper = [dataWrapper getDataWrapperForKey:@"classes"];
    if(classDataWrapper.count > 0)
    {
        NSMutableArray *classArray = [[NSMutableArray alloc] initWithCapacity:0];
        for (NSInteger i = 0; i < classDataWrapper.count; i++) {
            TNDataWrapper *classItemData = [classDataWrapper getDataWrapperForIndex:i];
            ClassInfo *classInfo = [[ClassInfo alloc] init];
            [classInfo parseData:classItemData];
            [classArray addObject:classInfo];
        }
        [self setClasses:classArray];
    }
    
    TNDataWrapper *teachesDataWrapper = [dataWrapper getDataWrapperForKey:@"teachers"];
    if(teachesDataWrapper.count > 0)
    {
        NSMutableArray *teacherArray = [[NSMutableArray alloc] initWithCapacity:0];
        for (NSInteger i = 0; i < teachesDataWrapper.count; i++) {
            TNDataWrapper *teacherWrapper = [teachesDataWrapper getDataWrapperForIndex:i];
            TeacherInfo *teacherInfo = [[TeacherInfo alloc] init];
            [teacherInfo parseData:teacherWrapper];
            [teacherArray addObject:teacherInfo];
        }
        [teacherArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            TeacherInfo *teacher1 = (TeacherInfo *)obj1;
            TeacherInfo *teacher2 = (TeacherInfo *)obj2;
            return ([teacher1.shortIndex compare:teacher2.shortIndex]);
        }];
        [self setTeachers:teacherArray];
    }
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super init])
    {
        self.schoolID = [aDecoder decodeObjectForKey:@"id"];
        self.schoolName = [aDecoder decodeObjectForKey:@"name"];
        self.logoUrl = [aDecoder decodeObjectForKey:@"logo"];
        self.classes = [aDecoder decodeObjectForKey:@"classes"];
        self.teachers = [aDecoder decodeObjectForKey:@"teachers"];
        self.schoolUrl = [aDecoder decodeObjectForKey:@"url"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.schoolID forKey:@"id"];
    [aCoder encodeObject:self.schoolName forKey:@"name"];
    [aCoder encodeObject:self.logoUrl forKey:@"logo"];
    [aCoder encodeObject:self.classes forKey:@"classes"];
    [aCoder encodeObject:self.teachers forKey:@"teachers"];
    [aCoder encodeObject:self.schoolUrl forKey:@"url"];
}
@end

@implementation TeacherInfo
- (void)parseData:(TNDataWrapper *)dataWrapper
{
    [super parseData:dataWrapper];
    self.uid = [dataWrapper getStringForKey:@"id"];
    self.shortIndex = [dataWrapper getStringForKey:@"first_letter"];
    self.name = [dataWrapper getStringForKey:@"name"];
    self.course = [dataWrapper getStringForKey:@"course"];
    self.mobile = [dataWrapper getStringForKey:@"mobile"];
    self.avatar = [dataWrapper getStringForKey:@"head"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super initWithCoder:aDecoder])
    {
        self.shortIndex = [aDecoder decodeObjectForKey:@"first_letter"];
        self.course = [aDecoder decodeObjectForKey:@"course"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:self.shortIndex forKey:@"first_letter"];
    [aCoder encodeObject:self.course forKey:@"course"];
}
@end

@implementation FamilyInfo
- (void)parseData:(TNDataWrapper *)dataWrapper
{
    self.uid = [dataWrapper getStringForKey:@"id"];
    self.name = [dataWrapper getStringForKey:@"name"];
    self.mobile = [dataWrapper getStringForKey:@"mobile"];
    self.relation = [dataWrapper getStringForKey:@"relation"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super initWithCoder:aDecoder])
    {
        self.relation = [aDecoder decodeObjectForKey:@"relation"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:self.relation forKey:@"relation"];
}

@end

@implementation ClassInfo
- (void)parseData:(TNDataWrapper *)dataWrapper
{
    self.classID = [dataWrapper getStringForKey:@"id"];
    self.className = [dataWrapper getStringForKey:@"name"];
    self.grade = [dataWrapper getStringForKey:@"grade"];
    self.logoUrl = [dataWrapper getStringForKey:@"logo"];
    self.course = [dataWrapper getStringForKey:@"course"];
    self.num = [dataWrapper getIntegerForKey:@"num"];
    
    TNDataWrapper *studentsDataWrapper = [dataWrapper getDataWrapperForKey:@"students"];
    if(studentsDataWrapper.count > 0)
    {
        NSMutableArray *studentArray = [[NSMutableArray alloc] initWithCapacity:0];
        for (NSInteger i = 0; i < studentsDataWrapper.count; i++) {
            TNDataWrapper *studentWrapper = [studentsDataWrapper getDataWrapperForIndex:i];
            StudentInfo *studentInfo = [[StudentInfo alloc] init];
            [studentInfo parseData:studentWrapper];
            [studentArray addObject:studentInfo];
        }
        [studentArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            StudentInfo *student1 = (StudentInfo *)obj1;
            StudentInfo *student2 = (StudentInfo *)obj2;
            return ([student1.shortIndex compare:student2.shortIndex]);
        }];
        [self setStudents:studentArray];
    }
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super init])
    {
        self.classID = [aDecoder decodeObjectForKey:@"id"];
        self.className = [aDecoder decodeObjectForKey:@"name"];
        self.grade = [aDecoder decodeObjectForKey:@"grade"];
        self.logoUrl = [aDecoder decodeObjectForKey:@"logo"];
        self.course = [aDecoder decodeObjectForKey:@"course"];
        NSMutableArray *students = [NSMutableArray arrayWithArray:[aDecoder decodeObjectForKey:@"students"]];
        [students sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            StudentInfo *student1 = (StudentInfo *)obj1;
            StudentInfo *student2 = (StudentInfo *)obj2;
            return ([student1.shortIndex compare:student2.shortIndex]);
        }];
        self.students = students;
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.classID forKey:@"id"];
     [aCoder encodeObject:self.className forKey:@"name"];
     [aCoder encodeObject:self.grade forKey:@"grade"];
     [aCoder encodeObject:self.logoUrl forKey:@"logo"];
     [aCoder encodeObject:self.course forKey:@"course"];
     [aCoder encodeObject:self.students forKey:@"students"];
}

@end



@implementation StudentInfo
- (void)parseData:(TNDataWrapper *)dataWrapper
{
    [super parseData:dataWrapper];
    self.shortIndex = [dataWrapper getStringForKey:@"first_letter"];
    TNDataWrapper *familyDataWrapper = [dataWrapper getDataWrapperForKey:@"family"];
    if(familyDataWrapper.count > 0)
    {
        NSMutableArray *familyArray = [[NSMutableArray alloc] initWithCapacity:0];
        for (NSInteger i = 0; i < familyDataWrapper.count; i++) {
            TNDataWrapper *familyItemData = [familyDataWrapper getDataWrapperForIndex:i];
            FamilyInfo *familyInfo = [[FamilyInfo alloc] init];
            [familyInfo parseData:familyItemData];
            [familyArray addObject:familyInfo];
        }
        [self setFamily:familyArray];
    }
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super initWithCoder:aDecoder])
    {
        self.shortIndex = [aDecoder decodeObjectForKey:@"first_letter"];
        self.family = [aDecoder decodeObjectForKey:@"family"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.uid forKey:@"id"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.avatar forKey:@"head"];
    [aCoder encodeInteger:self.gender forKey:@"sex"];
    [aCoder encodeObject:self.shortIndex forKey:@"first_letter"];
    [aCoder encodeObject:self.family forKey:@"family"];
}
@end
