//
//  ChatParentInfoVC.h
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/8/13.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"
#import "ChatTeacherInfoVC.h"

@interface ContactParentSchoolInfo : TNBaseObject
@property (nonatomic, copy)NSString *logo;
@property (nonatomic, copy)NSString *name;
@property (nonatomic, copy)NSString *url;
@property (nonatomic, copy)NSArray* classes;
@end

@interface ContactParentChildInfo : UserInfo
@property (nonatomic, strong)NSArray<ContactParentSchoolInfo *>* schools;
@end

@interface ContactParentInfo : UserInfo
@property (nonatomic, strong)NSArray<ContactParentChildInfo *>* children;
@end

@interface ContactParentChildCell : TNTableViewCell{
    AvatarView*     _avatar;
    NSMutableArray* _infoViewArray;
}
@property (nonatomic, strong)ContactParentChildInfo *childInfo;
@end

@interface ChatParentInfoVC : TNBaseViewController
@property (nonatomic, copy)NSString *label;
@property (nonatomic, strong)ContactParentInfo* parentInfo;
@property (nonatomic, copy)NSString *uid;
@property (nonatomic, copy)NSString *toObjid;
@end
