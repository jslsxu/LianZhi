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
SYNTHESIZE_SINGLETON_FOR_CLASS(ContactModel)
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
    BOOL canChat = NO;
    for (TeacherGroup *teacherGroup in schoolInfo.groups)
    {
        if(teacherGroup.canChat)
            canChat = YES;
    }
    
    if(schoolInfo.groups.count > 0 && canChat)
    {
        group = [[ContactGroup alloc] init];
        [self.teachers addObject:group];
        [group setKey:@"组"];
        for (TeacherGroup *teacherGroup in schoolInfo.groups)
        {
            if(teacherGroup.canChat)
                [group.contacts addObject:teacherGroup];
        }
    }
    
    for (TeacherInfo *teacher in schoolInfo.teachers) {
        if(![teacher.shortIndex isEqualToString:group.key])
        {
            group = [[ContactGroup alloc] init];
            [self.teachers addObject:group];
            [group setKey:teacher.shortIndex];
        }
        [group.contacts addObject:teacher];
    }
    
    NSInteger classNum = schoolInfo.classNum;
    if(classNum > 1)//多个班,按年级
    {
        [self.classes addObjectsFromArray:[UserCenter sharedInstance].curSchool.allClasses];
//        if([UserCenter sharedInstance].curSchool.classes.count > 0)
//        {
//            ContactGroup *group = [[ContactGroup alloc] init];
//            [group setKey:@"我教授的班"];
//            [group setContacts:[NSMutableArray arrayWithArray:[UserCenter sharedInstance].curSchool.classes]];
//            [self.classes addObject:group];
//        }
//    
//        if([UserCenter sharedInstance].curSchool.managedClasses.count > 0)
//        {
//            ContactGroup *group = [[ContactGroup alloc] init];
//            [group setKey:@"我管理的班"];
//            [group setContacts:[NSMutableArray arrayWithArray:[UserCenter sharedInstance].curSchool.managedClasses]];
//            [self.classes addObject:group];
//        }
    }
    else//一个班的话则把所有的学生按音序分组
    {
        group = nil;
        ClassInfo *classInfo = nil;
        if([UserCenter sharedInstance].curSchool.classes.count > 0)
            classInfo = [UserCenter sharedInstance].curSchool.classes[0];
        else
            classInfo = [UserCenter sharedInstance].curSchool.managedClasses[0];
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
