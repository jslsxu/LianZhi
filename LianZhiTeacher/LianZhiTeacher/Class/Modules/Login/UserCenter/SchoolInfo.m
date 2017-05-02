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
    self.classIMEnabled = [dataWrapper getBoolForKey:@"enabled_class_im"];
    TNDataWrapper *groupWrapper = [dataWrapper getDataWrapperForKey:@"groups"];
    if(groupWrapper.count > 0)
    {
        NSMutableArray *groupArray = [NSMutableArray array];
        for (NSInteger i = 0; i < groupWrapper.count; i++)
        {
            TNDataWrapper *groupItemWrapper = [groupWrapper getDataWrapperForIndex:i];
            TeacherGroup *group = [[TeacherGroup alloc] init];
            [group parseData:groupItemWrapper];
            [groupArray addObject:group];
        }
        self.groups = groupArray;
    }
    
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
    
    TNDataWrapper *managedClassesWrapper = [dataWrapper getDataWrapperForKey:@"managed_classes"];
    if(managedClassesWrapper.count > 0)
    {
        NSMutableArray *classArray = [[NSMutableArray alloc] initWithCapacity:0];
        for (NSInteger i = 0; i < managedClassesWrapper.count; i++) {
            TNDataWrapper *classItemData = [managedClassesWrapper getDataWrapperForIndex:i];
            ClassInfo *classInfo = [[ClassInfo alloc] init];
            [classInfo parseData:classItemData];
            [classArray addObject:classInfo];
        }
        [self setManagedClasses:classArray];
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
            return ([teacher1.first_letter compare:teacher2.first_letter]);
        }];
        [self setTeachers:teacherArray];
    }
}

- (BOOL)canSendNotification{
    NSInteger count = self.groups.count + self.classes.count + self.managedClasses.count;
    return count > 0;
}

- (NSInteger)classNum
{
    if(self.classes.count == 0)
        return self.managedClasses.count;
    else if(self.managedClasses.count == 0)
    {
        return self.classes.count;
    }
    else
    {
        NSInteger count = self.classes.count;
        for (ClassInfo *managedClassInfo in self.managedClasses)
        {
            BOOL isIn = NO;
            for (ClassInfo *classInfo in self.classes)
            {
                if([managedClassInfo.classID isEqualToString:classInfo.classID])
                    isIn = YES;
            }
            if(!isIn)
                count++;
        }
        return count;
    }
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super init])
    {
        self.schoolID = [aDecoder decodeObjectForKey:@"id"];
        self.schoolName = [aDecoder decodeObjectForKey:@"name"];
        self.logoUrl = [aDecoder decodeObjectForKey:@"logo"];
        self.groups = [aDecoder decodeObjectForKey:@"groups"];
        self.classes = [aDecoder decodeObjectForKey:@"classes"];
        self.managedClasses = [aDecoder decodeObjectForKey:@"managed_classes"];
        self.teachers = [aDecoder decodeObjectForKey:@"teachers"];
        self.schoolUrl = [aDecoder decodeObjectForKey:@"url"];
        if([aDecoder containsValueForKey:@"enabled_class_im"])
            self.classIMEnabled = [aDecoder decodeBoolForKey:@"enabled_class_im"];
        else
            self.classIMEnabled = YES;
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.schoolID forKey:@"id"];
    [aCoder encodeObject:self.schoolName forKey:@"name"];
    [aCoder encodeObject:self.logoUrl forKey:@"logo"];
    [aCoder encodeObject:self.groups forKey:@"groups"];
    [aCoder encodeObject:self.classes forKey:@"classes"];
    [aCoder encodeObject:self.managedClasses forKey:@"managed_classes"];
    [aCoder encodeObject:self.teachers forKey:@"teachers"];
    [aCoder encodeObject:self.schoolUrl forKey:@"url"];
    [aCoder encodeBool:self.classIMEnabled forKey:@"enabled_class_im"];
}

- (NSArray *)allClasses
{
    NSMutableArray *classArray = [NSMutableArray arrayWithArray:self.classes];
    for (ClassInfo *classInfo in self.managedClasses)
    {
        BOOL isIn = NO;
        for (ClassInfo *teachClass in classArray)
        {
            if([teachClass.classID isEqualToString:classInfo.classID])
                isIn = YES;
        }
        if(!isIn)
            [classArray addObject:classInfo];
    }
    if(classArray.count > 0)
        return classArray;
    return nil;
}
@end

@implementation TeacherInfo
- (void)parseData:(TNDataWrapper *)dataWrapper
{
    [self modelSetWithJSON:dataWrapper.data];
}


@end

@implementation FamilyInfo
- (void)parseData:(TNDataWrapper *)dataWrapper
{
    [self modelSetWithJSON:dataWrapper.data];
}


@end

@implementation GradeInfo

- (void)parseData:(TNDataWrapper *)dataWrapper{
    [self modelSetWithJSON:dataWrapper.data];
}

@end

@implementation ClassInfo

- (BOOL)isEqual:(id)object
{
    if([object isKindOfClass:[self class]])
    {
        ClassInfo *classInfo = (ClassInfo *)object;
        return ([classInfo.classID isEqualToString:self.classID] && [classInfo.name isEqualToString:self.name]);
    }
    return NO;
}

- (void)parseData:(TNDataWrapper *)dataWrapper
{
    [self modelSetWithJSON:dataWrapper.data];
}

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"students" : [StudentInfo class]};
}

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    return @{@"classID" : @[@"id", @"classid"]};
}
- (SelectedType)selectedType{
    NSInteger count = 0;
    for (StudentInfo *studentInfo in self.students) {
        if(studentInfo.selected){
            count ++;
        }
    }
    if(count == 0){
        return SelectedTypeNone;
    }
    else if(count == self.students.count){
        return SelectedTypeAll;
    }
    else{
        return SelectedTypePartly;
    }
}

- (void)selectAll{
    for (StudentInfo *studentInfo in self.students) {
        studentInfo.selected = YES;
    }
}

- (void)clearSelect{
    for (StudentInfo *studentInfo in self.students) {
        studentInfo.selected = NO;
    }
}

- (NSInteger)selectedNum{
    NSInteger count = 0;
    for (StudentInfo *studentInfo in self.students) {
        if(studentInfo.selected){
            count++;
        }
    }
    return count;
}
@end



@implementation StudentInfo
- (void)parseData:(TNDataWrapper *)dataWrapper
{
    [self modelSetWithJSON:dataWrapper.data];
}

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"family" : [FamilyInfo class]};
}

@end

@implementation TeacherGroup

- (void)parseData:(TNDataWrapper *)dataWrapper
{
    [self modelSetWithJSON:dataWrapper.data];
}

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    return @{@"groupID" : @"id",
             @"groupName" : @"name",
             @"canNotice" : @"can_notice"};
}

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"teachers" : [TeacherInfo class]};
}

+ (nullable NSArray<NSString *> *)modelPropertyBlacklist{
    return @[@"selected"];
}

- (BOOL)canChat
{
    for (TeacherInfo *teacherInfo in self.teachers)
    {
        if([teacherInfo.uid isEqualToString:[UserCenter sharedInstance].userInfo.uid])
            return YES;
    }
    return NO;
}

- (SelectedType)selectedType{
    NSInteger count = 0;
    for (TeacherInfo *teacherInfo in self.teachers) {
        if(teacherInfo.selected){
            count ++;
        }
    }
    if(count == 0){
        return SelectedTypeNone;
    }
    else if(count == self.teachers.count){
        return SelectedTypeAll;
    }
    else{
        return SelectedTypePartly;
    }
}

- (void)selectAll{
    for (TeacherInfo *teacherInfo in self.teachers) {
        teacherInfo.selected = YES;
    }
}

- (void)clearSelect{
    for (TeacherInfo *teacherInfo in self.teachers) {
        teacherInfo.selected = NO;
    }
}

- (NSInteger)selectedNum{
    NSInteger count = 0;
    for (TeacherInfo *teacherInfo in self.teachers) {
        if(teacherInfo.selected){
            count ++;
        }
    }
    return count;
}

@end
