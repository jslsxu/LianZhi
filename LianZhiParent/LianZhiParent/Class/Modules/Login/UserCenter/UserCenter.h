//
//  UserCenter.h
//  LianZhiParent
//
//  Created by jslsxu on 15/1/9.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChildInfo.h"
#import "LogConfig.h"
#import "PersonalSetting.h"
#import "StatusManager.h"
extern NSString* const kUserCenterChangedCurChildNotification;
extern NSString* const kUserInfoChangedNotification;
extern NSString* const kPersonalSettingChangedNotification;
extern NSString* const kChildInfoChangedNotification;
extern NSString* const kUserDataStorageKey;
@interface UserData : TNModelItem
@property (nonatomic, strong)UserInfo *userInfo;
@property (nonatomic, copy)NSString *accessToken;
@property (nonatomic, assign)BOOL firstLogin;
@property (nonatomic, strong)LogConfig *config;
@property (nonatomic, assign)BOOL confirmed;
@property (nonatomic, strong)NSMutableArray*   children;
@property (nonatomic, assign)NSInteger curChildIndex;

- (void)updateChildren:(TNDataWrapper *)childrenWrapper;
@end

@interface UserCenter : TNModelItem
@property (nonatomic, copy)NSString *deviceToken;
@property (nonatomic, strong)UserData *userData;
@property (nonatomic, strong)PersonalSetting *personalSetting;
@property (nonatomic, strong)StatusManager *statusManager;
@property (nonatomic, assign)BOOL isLoadingContacts;
- (UserInfo *)userInfo;
- (NSArray *)children;
- (ChildInfo *)curChild;
- (void)setCurChild:(ChildInfo *)curChild;
SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(UserCenter)
- (void)updateUserInfoWithData:(TNDataWrapper *)userWrapper;
- (void)updateChildren;
- (void)save;
- (BOOL)hasLogin;
- (void)logout;
- (void)requestNoDisturbingTime;
- (void)setNoDisturbindTime;
@end
