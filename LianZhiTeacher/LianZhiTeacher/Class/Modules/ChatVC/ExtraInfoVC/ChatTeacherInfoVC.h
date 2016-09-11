//
//  ChatTeacherInfoVC.h
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/8/13.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"

@interface ContactClassInfo : TNBaseObject
@property (nonatomic, copy)NSString *class_name;
@property (nonatomic, copy)NSString *course;
@end

@interface ContactSchoolInfo : TNBaseObject
@property (nonatomic, copy)NSString *logo;
@property (nonatomic, copy)NSString *name;
@property (nonatomic, copy)NSString *url;
@property (nonatomic, copy)NSArray* classes;
@end

@interface ContactTeacherInfo : UserInfo
@property (nonatomic, strong)NSArray<ContactSchoolInfo *>* schools;
@end

@interface ContactTeacherSchoolCell : TNTableViewCell{
    LogoView*   _logoView;
    UILabel*    _nameLabel;
    NSMutableArray* _classViewArray;
}
@property (nonatomic, strong)ContactSchoolInfo *schoolInfo;
@end

@interface ChatTeacherInfoVC : TNBaseViewController
@property (nonatomic, strong)ContactTeacherInfo *teacherInfo;
@property (nonatomic, copy)NSString *uid;
@end
