//
//  ContactModel.m
//  LianZhiParent
//
//  Created by jslsxu on 14/12/18.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "ContactModel.h"

@implementation ContactGroup

- (id)init
{
    self = [super init];
    if(self)
    {
        NSMutableArray *contactsArray = [[NSMutableArray alloc] initWithCapacity:0];
        [self setContacts:contactsArray];
    }
    return self;
}
@end

@implementation ContactModel

- (id)init
{
    self = [super init];
    if(self)
    {
        self.classes = [[NSMutableArray alloc] initWithCapacity:0];
        self.students = [[NSMutableArray alloc] initWithCapacity:0];
        self.teachers = [[NSMutableArray alloc] initWithCapacity:0];
        [self refresh];
    }
    return self;
}

- (NSArray *)classKeys
{
    NSMutableArray *keys = [NSMutableArray array];
    for (ContactGroup *group in self.classes) {
        [keys addObject:group.key];
    }
    return keys;
}

- (NSArray *)teacherKeys
{
    NSMutableArray *keys = [NSMutableArray array];
    for (ContactGroup *group in self.teachers) {
        [keys addObject:group.key];
    }
    return keys;
}

- (NSArray *)studentsKeys
{
    NSMutableArray *keys = [NSMutableArray array];
    for (ContactGroup *group in self.students) {
        [keys addObject:group.key];
    }
    return keys;
}

- (void)refresh
{
    [self.students removeAllObjects];
    [self.teachers removeAllObjects];
    [self.classes removeAllObjects];
    SchoolInfo *schoolInfo = [UserCenter sharedInstance].curSchool;
    ContactGroup *group = nil;
    for (TeacherInfo *teacher in schoolInfo.teachers) {
        if(![teacher.shortIndex isEqualToString:group.key])
        {
            group = [[ContactGroup alloc] init];
            [self.teachers addObject:group];
            [group setKey:teacher.shortIndex];
        }
        [group.contacts addObject:teacher];
    }
    
    NSArray *classes = schoolInfo.classes;
    if(classes.count > 1)//多个班,按年级
    {
        NSMutableArray *allGradeSet = [[NSMutableArray alloc] init];
        for (ClassInfo *classInfo in schoolInfo.classes) {
            BOOL contains = NO;
            for (NSString *key in allGradeSet) {
                if([key isEqualToString:classInfo.grade])
                    contains = YES;
            }
            if(!contains)
                [allGradeSet addObject:classInfo.grade];
        }
        
        for (NSString *key in allGradeSet) {
            group = [[ContactGroup alloc] init];
            [group setKey:key];
            for (ClassInfo *classInfo in schoolInfo.classes) {
                if([classInfo.grade isEqualToString:key])
                {
                    [group.contacts addObject:classInfo];
                }
            }
            [self.classes addObject:group];
        }
    
    }
    else//一个班的话则把所有的学生按音序分组
    {
        group = nil;
        ClassInfo *classInfo = [classes objectAtIndex:0];
        NSArray *students = classInfo.students;
        NSMutableDictionary *studentDic = [[NSMutableDictionary alloc] initWithCapacity:0];
        for (StudentInfo *student in students)
        {
            NSString *key = student.shortIndex;
            ContactGroup *studentGroup = [studentDic objectForKey:key];
            if(studentGroup == nil)
            {
                studentGroup = [[ContactGroup alloc] init];
                [studentGroup setKey:key];
                [studentDic setObject:studentGroup forKey:key];
            }
            [studentGroup.contacts addObject:student];
        }
        NSArray *allKeys = [studentDic allKeys];
        for (NSString *key in allKeys) {
            [self.students addObject:[studentDic objectForKey:key]];
        }
        
        [self.students sortUsingComparator:^NSComparisonResult(ContactGroup* obj1, ContactGroup* obj2) {
            NSString *index1 = obj1.key;
            NSString *index2 = obj2.key;
            return [index1 compare:index2];
            
        }];
    }
}


@end
