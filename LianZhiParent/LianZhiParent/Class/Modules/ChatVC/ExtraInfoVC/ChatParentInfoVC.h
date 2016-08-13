//
//  ChatParentInfoVC.h
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/8/13.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"
#import "ChatTeacherInfoVC.h"
@interface ContactParentChildInfo : UserInfo
@property (nonatomic, strong)NSArray<ContactSchoolInfo *>* schools;
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
@property (nonatomic, strong)ContactParentInfo* parentInfo;
@end