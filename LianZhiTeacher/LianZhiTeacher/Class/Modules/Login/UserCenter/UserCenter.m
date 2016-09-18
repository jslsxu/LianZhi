//
//  UserCenter.m
//  LianZhiParent
//
//  Created by jslsxu on 15/1/9.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "UserCenter.h"

NSString *const kUserCenterChangedSchoolNotification = @"UserCenterChangeSchoolNotification";
NSString *const kUserCenterSchoolSchemeChangedNotification = @"UserCenterSchoolSchemeChangedNotification";
NSString *const kUserInfoChangedNotification = @"UserInfoChangedNotification";
NSString *const kPersonalSettingChangedNotification = @"PersonalSettingChangedNotification";
NSString *const kUserDataStorageKey = @"UserData";
@implementation UserData
- (void)parseData:(TNDataWrapper *)dataWrapper
{
    self.firstLogin = [dataWrapper getBoolForKey:@"first_login"];
    self.confirmed = [dataWrapper getBoolForKey:@"confirmed"];
    NSString *verify = [dataWrapper getStringForKey:@"verify"];
    if(verify.length > 0)
        self.accessToken = verify;
    
    TNDataWrapper *configWrapper = [dataWrapper getDataWrapperForKey:@"config"];
    if(configWrapper.count)
    {
        LogConfig *logConfig = [[LogConfig alloc] init];
        [logConfig parseData:configWrapper];
        self.config = logConfig;
    }
    TNDataWrapper *userDataWrapper = [dataWrapper getDataWrapperForKey:@"user"];
    if(userDataWrapper.count > 0)
    {
        UserInfo *userInfo = [[UserInfo alloc] init];
        [userInfo parseData:userDataWrapper];
        [self setUserInfo:userInfo];
    }
    
    TNDataWrapper *schoolListWrapper = [dataWrapper getDataWrapperForKey:@"schools"];
    if(schoolListWrapper.count > 0)
    {
        NSMutableArray *schoolArray = [[NSMutableArray alloc] initWithCapacity:0];
        for (NSInteger i = 0; i < schoolListWrapper.count; i++) {
            TNDataWrapper *schoolDataWrapper = [schoolListWrapper getDataWrapperForIndex:i];
            SchoolInfo *schoolInfo = [[SchoolInfo alloc] init];
            [schoolInfo parseData:schoolDataWrapper];
            [schoolArray addObject:schoolInfo];
        }
        
        [schoolArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            SchoolInfo *schoolInfo1 = (SchoolInfo *)obj1;
            SchoolInfo *schoolInfo2 = (SchoolInfo *)obj2;
            return [schoolInfo1.schoolID compare:schoolInfo2.schoolID];
        }];
        self.schools = schoolArray;
    }
    
}

- (void)updateSchools:(TNDataWrapper *)dataWrapper{
    if(dataWrapper.count > 0)
    {
        NSMutableArray *schoolArray = [[NSMutableArray alloc] initWithCapacity:0];
        for (NSInteger i = 0; i < dataWrapper.count; i++) {
            TNDataWrapper *schoolDataWrapper = [dataWrapper getDataWrapperForIndex:i];
            SchoolInfo *schoolInfo = [[SchoolInfo alloc] init];
            [schoolInfo parseData:schoolDataWrapper];
            [schoolArray addObject:schoolInfo];
        }
        
        [schoolArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            SchoolInfo *schoolInfo1 = (SchoolInfo *)obj1;
            SchoolInfo *schoolInfo2 = (SchoolInfo *)obj2;
            return [schoolInfo1.schoolID compare:schoolInfo2.schoolID];
        }];
        self.schools = schoolArray;
    }

}

@end


@implementation UserCenter
SYNTHESIZE_SINGLETON_FOR_CLASS(UserCenter)

- (id)init
{
    self = [super init];
    if(self)
    {
        self.userData = [[LZKVStorage applicationKVStorage] storageValueForKey:kUserDataStorageKey];
        self.statusManager = [[StatusManager alloc] init];
    }
    return self;
}

- (PersonalSetting *)personalSetting{
    if(!_personalSetting){
        _personalSetting = [[LZKVStorage userKVStorage] storageValueForKey:kPersonalSettingKey];
    }
    if(!_personalSetting){
        _personalSetting = [[PersonalSetting alloc] init];
    }
    return _personalSetting;
}

- (void)parseData:(TNDataWrapper *)dataWrapper
{
    if(dataWrapper.count > 0)
    {
        UserData *userData = [[UserData alloc] init];
        [userData parseData:dataWrapper];
        self.userData = userData;
        [self save];
    }
}


- (BOOL)hasLogin
{
    return (self.userData.accessToken.length > 0);
}

- (NSArray *)schools
{
    return self.userData.schools;
}

- (SchoolInfo *)curSchool
{
    if(self.userData.schools.count > self.userData.curIndex)
        return self.userData.schools[self.userData.curIndex];
    else
        return nil;
}

- (UserInfo *)userInfo
{
    return self.userData.userInfo;
}

- (void)updateUserInfoWithData:(TNDataWrapper *)userWrapper;
{
    [self.userData.userInfo parseData:userWrapper];
    [self save];
}

- (void)updateSchoolInfo{
    if(!self.isLoadingContacts){
        self.isLoadingContacts = YES;
        [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"user/get_related_info" method:REQUEST_GET type:REQUEST_REFRESH withParams:nil observer:self completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
            self.isLoadingContacts = NO;
            TNDataWrapper *schoolListWrapper = [responseObject getDataWrapperForKey:@"schools"];
            if(schoolListWrapper.count > 0){
                [self.userData updateSchools:schoolListWrapper];
                [self save];
                [[NSNotificationCenter defaultCenter] postNotificationName:kUserInfoContactsChangedNotificaiotn object:nil];
            }
        } fail:^(NSString *errMsg) {
            self.isLoadingContacts = NO;
             [[NSNotificationCenter defaultCenter] postNotificationName:kUserInfoContactsChangedNotificaiotn object:nil];
        }];
    }
}

- (void)save
{
    [[LZKVStorage applicationKVStorage] saveStorageValue:self.userData forKey:kUserDataStorageKey];
}


- (void)changeCurSchool:(SchoolInfo *)schoolInfo
{
    NSInteger index = [self.userData.schools indexOfObject:schoolInfo];
    if(self.userData.curIndex != index)
    {
        self.userData.curIndex = index;
        [[NSNotificationCenter defaultCenter] postNotificationName:kUserCenterChangedSchoolNotification object:self userInfo:nil];
        [self save];
    }
}

- (BOOL)teachAtCurSchool
{
    return (self.curSchool.classes.count > 0);
}

- (void)logout
{
    self.userData = nil;
    self.statusManager = [[StatusManager alloc] init];
    [[LZKVStorage applicationKVStorage] saveStorageValue:nil forKey:kUserDataStorageKey];
}

- (void)requestNoDisturbingTime
{
    [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"setting/get_personal" method:REQUEST_GET type:REQUEST_REFRESH withParams:nil observer:nil completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
        self.personalSetting.startTime = [responseObject getStringForKey:@"no_disturbing_begin"];
        self.personalSetting.endTime = [responseObject getStringForKey:@"no_disturbing_end"];
        self.personalSetting.noDisturbing = [responseObject getBoolForKey:@"no_disturbing"];
        [self save];
    } fail:^(NSString *errMsg) {
        
    }];
}

- (void)setNoDisturbindTime
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.personalSetting.startTime forKey:@"no_disturbing_begin"];
    [params setValue:self.personalSetting.endTime forKey:@"no_disturbing_end"];
    [params setValue:kStringFromValue(self.personalSetting.noDisturbing) forKey:@"no_disturbing"];
    [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"setting/set_personal" method:REQUEST_GET type:REQUEST_REFRESH withParams:params observer:nil completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
    } fail:^(NSString *errMsg) {
        
    }];
}

@end
