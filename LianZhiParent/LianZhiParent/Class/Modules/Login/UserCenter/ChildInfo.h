//
//  ChildInfo.h
//  LianZhiParent
//
//  Created by jslsxu on 15/1/10.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef CF_ENUM(NSInteger, GenderType) {
    GenderMale = 0,
    GenderFemale,
    GenderSecret,
};

@interface SchoolInfo : TNModelItem<NSCoding>
@property (nonatomic, copy)NSString *schoolID;
@property (nonatomic, copy)NSString *schoolName;
@property (nonatomic, copy)NSString *logo;
@property (nonatomic, assign)BOOL classIMEnaled;
@end

@interface TeacherInfo : UserInfo<NSCoding>
@property (nonatomic, copy)NSString *course;
//@property (nonatomic, copy)NSString *mobile;
@property (nonatomic, copy)NSString *teacherName;
@end

@interface ClassInfo : TNModelItem<NSCoding>
@property (nonatomic, copy)NSString *classID;
@property (nonatomic, copy)NSString *className;
@property (nonatomic, copy)NSString *logo;
@property (nonatomic, strong)SchoolInfo *schoolInfo;
@property (nonatomic, strong)NSArray *teachers;
@property (nonatomic, strong)NSArray *students;

@end

@interface FamilyInfo : UserInfo<NSCoding>
@property (nonatomic, copy)NSString *relation;

@end


@interface ChildInfo : UserInfo<NSCoding>
//@property (nonatomic, copy)NSString *uid;
//@property (nonatomic, copy)NSString *name;
//@property (nonatomic, copy)NSString *avatar;
//@property (nonatomic, copy)NSString *nickName;
@property (nonatomic, copy)NSString *birthday;
//@property (nonatomic, copy)NSString *constellation;
@property (nonatomic, copy)NSString *height;
//@property (nonatomic, assign)GenderType gender;
@property (nonatomic, copy)NSString *weight;
@property (nonatomic, strong)NSArray *family;
@property (nonatomic, strong)NSArray *classes;
@property (nonatomic, assign)BOOL hasNew;
@end
