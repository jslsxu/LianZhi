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
@property (nonatomic, copy)NSString *logoUrl;
@property (nonatomic, strong)NSArray *classes;
@property (nonatomic, strong)NSArray *teachers;
@property (nonatomic, copy)NSString *schoolUrl;
@end

@interface TeacherInfo : UserInfo
//@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *course;

@end

@interface FamilyInfo : UserInfo
@property (nonatomic, copy)NSString *relation;

@end

@interface StudentInfo : UserInfo
//@property (nonatomic, assign)GenderType gender;
@property (nonatomic, strong)NSArray *family;
@property (nonatomic, assign)BOOL selected;             //在班级操作中有用
@property (nonatomic, assign)NSInteger attention;       //关注度
@property (nonatomic, assign)BOOL showFocus;
@end

@interface ClassInfo : TNModelItem<NSCoding>
@property (nonatomic, copy)NSString *course;
@property (nonatomic, copy)NSString *grade;
@property (nonatomic, copy)NSString *classID;
@property (nonatomic, copy)NSString *className;
@property (nonatomic, copy)NSString *logoUrl;
@property (nonatomic, strong)NSMutableArray *students;
@property (nonatomic, assign)BOOL recordEnabled;//是否开通成长记录
@property (nonatomic, assign)BOOL canSelected;
@property (nonatomic, assign)BOOL selected;             //在班级操作中有用
@property (nonatomic, assign)NSInteger num;
@end

