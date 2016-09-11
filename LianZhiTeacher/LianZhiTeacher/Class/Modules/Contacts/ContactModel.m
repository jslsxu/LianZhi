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
        self.teachers = [[NSMutableArray alloc] initWithCapacity:0];
        [self refresh];
    }
    return self;
}
- (NSArray *)titleArray{
    NSMutableArray *array = [NSMutableArray array];
    if([self.classes count] > 0){
        [array addObject:kParentTitle];
    }
    if([self.teachers count] > 0){
        [array addObject:kTeacherTitle];
    }
    return array;
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
        [group setKey:@"群"];
        for (TeacherGroup *teacherGroup in schoolInfo.groups)
        {
            if(teacherGroup.canChat)
                [group.contacts addObject:teacherGroup];
        }
    }
    
    for (TeacherInfo *teacher in schoolInfo.teachers) {
        if(![teacher.first_letter isEqualToString:group.key])
        {
            group = [[ContactGroup alloc] init];
            [self.teachers addObject:group];
            [group setKey:teacher.first_letter];
        }
        [group.contacts addObject:teacher];
    }
    
    [self.classes addObjectsFromArray:[UserCenter sharedInstance].curSchool.allClasses];
}


@end
