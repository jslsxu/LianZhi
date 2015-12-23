//
//  ChildInfo.m
//  LianZhiParent
//
//  Created by jslsxu on 15/1/10.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "ChildInfo.h"
@implementation SchoolInfo

- (void)parseData:(TNDataWrapper *)dataWrapper
{
    self.schoolID = [dataWrapper getStringForKey:@"id"];
    self.schoolName = [dataWrapper getStringForKey:@"name"];
    self.logo = [dataWrapper getStringForKey:@"logo"];
    self.classIMEnaled = [dataWrapper getBoolForKey:@"enabled_class_im"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super init])
    {
        self.schoolID = [aDecoder decodeObjectForKey:@"id"];
        self.schoolName = [aDecoder decodeObjectForKey:@"name"];
        self.logo = [aDecoder decodeObjectForKey:@"logo"];
        if([aDecoder containsValueForKey:@"enabled_class_im"])
            self.classIMEnaled = [aDecoder decodeBoolForKey:@"enabled_class_im"];
        else
            self.classIMEnaled = YES;
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.schoolID forKey:@"id"];
    [aCoder encodeObject:self.schoolName forKey:@"name"];
    [aCoder encodeObject:self.logo forKey:@"logo"];
    [aCoder encodeBool:self.classIMEnaled forKey:@"enabled_class_im"];
}
@end

@implementation TeacherInfo
- (void)parseData:(TNDataWrapper *)dataWrapper
{
    [super parseData:dataWrapper];
    self.uid = [dataWrapper getStringForKey:@"id"];
    self.teacherName = [dataWrapper getStringForKey:@"name"];
    self.course = [dataWrapper getStringForKey:@"course"];
    self.mobile = [dataWrapper getStringForKey:@"mobile"];
    self.avatar = [dataWrapper getStringForKey:@"head"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super initWithCoder:aDecoder])
    {
        self.uid = [aDecoder decodeObjectForKey:@"id"];
        self.teacherName = [aDecoder decodeObjectForKey:@"name"];
        self.course = [aDecoder decodeObjectForKey:@"course"];
        self.mobile = [aDecoder decodeObjectForKey:@"mobile"];
        self.avatar = [aDecoder decodeObjectForKey:@"avatar"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:self.uid forKey:@"id"];
    [aCoder encodeObject:self.teacherName forKey:@"name"];
    [aCoder encodeObject:self.course forKey:@"course"];
    [aCoder encodeObject:self.mobile forKey:@"mobile"];
    [aCoder encodeObject:self.avatar forKey:@"avatar"];
}
@end

@implementation ClassInfo
- (void)parseData:(TNDataWrapper *)dataWrapper
{
    self.classID = [dataWrapper getStringForKey:@"id"];
    self.className = [dataWrapper getStringForKey:@"name"];
    self.logo = [dataWrapper getStringForKey:@"logo"];
    TNDataWrapper *schoolDataWrapper = [dataWrapper getDataWrapperForKey:@"school"];
    SchoolInfo *schoolInfo = [[SchoolInfo alloc] init];
    [schoolInfo parseData:schoolDataWrapper];
    self.schoolInfo = schoolInfo;
    
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
        [self setTeachers:teacherArray];
    }
    
    TNDataWrapper *studentsDataWrapper = [dataWrapper getDataWrapperForKey:@"students"];
    if(studentsDataWrapper.count > 0)
    {
        NSMutableArray *studentArray = [[NSMutableArray alloc] initWithCapacity:0];
        for (NSInteger i = 0; i < studentsDataWrapper.count; i++) {
            TNDataWrapper *studentWrapper = [studentsDataWrapper getDataWrapperForIndex:i];
            ChildInfo *childInfo = [[ChildInfo alloc] init];
            [childInfo parseData:studentWrapper];
            [studentArray addObject:childInfo];
        }
        [self setStudents:studentArray];
    }
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
   if(self = [super init])
   {
       self.classID = [aDecoder decodeObjectForKey:@"id"];
       self.className = [aDecoder decodeObjectForKey:@"name"];
       self.logo = [aDecoder decodeObjectForKey:@"logo"];
       self.schoolInfo = [aDecoder decodeObjectForKey:@"school"];
       self.teachers = [aDecoder decodeObjectForKey:@"teachers"];
   }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.classID forKey:@"id"];
    [aCoder encodeObject:self.className forKey:@"name"];
    [aCoder encodeObject:self.logo forKey:@"logo"];
    [aCoder encodeObject:self.schoolInfo forKey:@"school"];
    [aCoder encodeObject:self.teachers forKey:@"teachers"];
}
@end

@implementation FamilyInfo
- (void)parseData:(TNDataWrapper *)dataWrapper
{
    [super parseData:dataWrapper];
    self.uid = [dataWrapper getStringForKey:@"id"];
    self.name = [dataWrapper getStringForKey:@"name"];
    self.mobile = [dataWrapper getStringForKey:@"mobile"];
    self.relation = [dataWrapper getStringForKey:@"relation"];
    self.avatar = [dataWrapper getStringForKey:@"head"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super initWithCoder:aDecoder])
    {
        self.uid = [aDecoder decodeObjectForKey:@"id"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.mobile = [aDecoder decodeObjectForKey:@"mobile"];
        self.relation = [aDecoder decodeObjectForKey:@"relation"];
        self.avatar = [aDecoder decodeObjectForKey:@"head"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:self.uid forKey:@"id"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.mobile forKey:@"mobile"];
    [aCoder encodeObject:self.relation forKey:@"relation"];
    [aCoder encodeObject:self.avatar forKey:@"head"];
}
@end


@implementation ChildInfo
- (void)parseData:(TNDataWrapper *)dataWrapper
{
    [super parseData:dataWrapper];
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
    
    self.uid = [dataWrapper getStringForKey:@"id"];
    self.name = [dataWrapper getStringForKey:@"name"];
    self.avatar = [dataWrapper getStringForKey:@"head"];
    self.nickName = [dataWrapper getStringForKey:@"nick"];
    self.birthday = [dataWrapper getStringForKey:@"birthday"];
    self.constellation = [dataWrapper getStringForKey:@"constellation"];
    self.height = [dataWrapper getStringForKey:@"height"];
    self.weight = [dataWrapper getStringForKey:@"weight"];
    self.gender = [dataWrapper getIntegerForKey:@"sex"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super initWithCoder:aDecoder])
    {
        self.uid = [aDecoder decodeObjectForKey:@"id"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.avatar = [aDecoder decodeObjectForKey:@"head"];
        self.nickName = [aDecoder decodeObjectForKey:@"nick"];
        self.birthday = [aDecoder decodeObjectForKey:@"birthday"];
        self.constellation = [aDecoder decodeObjectForKey:@"constellation"];
        self.height = [aDecoder decodeObjectForKey:@"height"];
        self.weight = [aDecoder decodeObjectForKey:@"weight"];
        self.gender = [aDecoder decodeIntegerForKey:@"sex"];
        self.classes = [aDecoder decodeObjectForKey:@"classes"];
        self.family = [aDecoder decodeObjectForKey:@"family"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:self.uid forKey:@"id"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.avatar forKey:@"head"];
    [aCoder encodeObject:self.nickName forKey:@"nick"];
    [aCoder encodeObject:self.birthday forKey:@"birthday"];
    [aCoder encodeObject:self.constellation forKey:@"constellation"];
    [aCoder encodeObject:self.height forKey:@"height"];
    [aCoder encodeObject:self.weight forKey:@"weight"];
    [aCoder encodeInteger:self.gender forKey:@"sex"];
    [aCoder encodeObject:self.classes forKey:@"classes"];
    [aCoder encodeObject:self.family forKey:@"family"];
}
@end
