//
//  GrowthClassListModel.h
//  LianZhiTeacher
//
//  Created by jslsxu on 17/2/6.
//  Copyright © 2017年 jslsxu. All rights reserved.
//

#import "TNListModel.h"

typedef NS_ENUM(NSInteger, GrowthStatusType){
    GrowthStatusNotSend = 0,
    GrowthStatusHasSend = 1,
    GrowthStatusReplied = 2,
    GrowthStatusAbsence = 3,
    GrowthStatusNum = 4,
};

@interface GrowthStudentInfo : TNBaseObject
@property (nonatomic, copy)NSString* uid;
@property (nonatomic, copy)NSString* avatar;
@property (nonatomic, copy)NSString* name;
@property (nonatomic, assign)GrowthStatusType status;
@property (nonatomic, assign)BOOL selected;
@property (nonatomic, assign)CGFloat score;
@end

@interface GrowthClassInfo : TNBaseObject
@property (nonatomic, copy)NSString* logo;
@property (nonatomic, copy)NSString* name;
@property (nonatomic, strong)NSArray* students;
- (BOOL)hasNew;
@end

@interface GrowthClassListModel : TNListModel
@end
