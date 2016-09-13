//
//  UserCenter.h
//  LianZhiParent
//
//  Created by jslsxu on 15/1/9.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SchoolInfo.h"
#import "LogConfig.h"
#import "PersonalSetting.h"
#import "StatusManager.h"
extern NSString* const kUserCenterChangedSchoolNotification;
extern NSString* const kUserCenterSchoolSchemeChangedNotification;      //学校布局需要改变
extern NSString* const kUserInfoChangedNotification;
extern NSString *const kPersonalSettingChangedNotification;
extern NSString* const kUserDataStorageKey;
@interface UserData : TNModelItem<NSCoding>
@property (nonatomic, strong)UserInfo *userInfo;
@property (nonatomic, copy)NSString *accessToken;
@property (nonatomic, assign)BOOL firstLogin;
@property (nonatomic, assign)BOOL confirmed;
@property (nonatomic, strong)LogConfig *config;
@property (nonatomic, strong)NSArray*   schools;
@property (nonatomic, assign)NSInteger curIndex;
- (void)updateSchools:(TNDataWrapper *)dataWrapper;
@end


@interface UserCenter : TNModelItem
@property (nonatomic, copy)NSString *deviceToken;
@property (nonatomic, strong)UserData *userData;
@property (nonatomic, strong)PersonalSetting *personalSetting;
@property (nonatomic, strong)StatusManager *statusManager;
@property (nonatomic, assign)BOOL isLoadingContacts;
SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(UserCenter)
- (NSArray *)schools;
- (SchoolInfo *)curSchool;
- (UserInfo *)userInfo;
- (void)updateUserInfoWithData:(TNDataWrapper *)userWrapper;
- (void)updateSchoolInfo;              //更新学校联系人信息
- (void)save;
- (BOOL)hasLogin;
- (void)changeCurSchool:(SchoolInfo *)schoolInfo;
- (void)logout;
- (BOOL)teachAtCurSchool;
- (void)requestNoDisturbingTime;
- (void)setNoDisturbindTime;
@end
