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


- (void)refresh
{
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


@end
