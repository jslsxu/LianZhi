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
#define kUserCenterCacheFile            @"lianzhiTeacherUser"

@implementation UserData
- (void)parseData:(TNDataWrapper *)dataWrapper
{
    if(dataWrapper)
    {
        TNDataWrapper *userDataWrapper = [dataWrapper getDataWrapperForKey:@"user"];
        if(userDataWrapper.count > 0)
        {
            UserInfo *userInfo = [[UserInfo alloc] init];
            [userInfo parseData:userDataWrapper];
            [self setUserInfo:userInfo];
        }
        
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
            self.schools = schoolArray;
        }
    }
    
}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super init])
    {
        self.userInfo = [aDecoder decodeObjectForKey:@"user"];
        self.firstLogin = [aDecoder decodeBoolForKey:@"first_login"];
        self.accessToken = [aDecoder decodeObjectForKey:@"verify"];
        self.curIndex = [aDecoder decodeIntegerForKey:@"curIndex"];
        self.config = [aDecoder decodeObjectForKey:@"config"];
        self.schools = [aDecoder decodeObjectForKey:@"schools"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.userInfo forKey:@"user"];
    [aCoder encodeBool:self.firstLogin forKey:@"first_login"];
    [aCoder encodeObject:self.accessToken forKey:@"verify"];
    [aCoder encodeInteger:self.curIndex forKey:@"curIndex"];
    [aCoder encodeObject:self.config forKey:@"config"];
    [aCoder encodeObject:self.schools forKey:@"schools"];
}

@end


@implementation UserCenter
SYNTHESIZE_SINGLETON_FOR_CLASS(UserCenter)

- (id)init
{
    self = [super init];
    if(self)
    {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSData *userData = [userDefaults objectForKey:@"userData"];
        if(userData)
        {
            self.userData = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
        }
        
        NSData *personalSettingData = [userDefaults objectForKey:kPersonalSettingKey];
        if(personalSettingData)
            self.personalSetting = [NSKeyedUnarchiver unarchiveObjectWithData:personalSettingData];
        if(!self.personalSetting)
            self.personalSetting = [[PersonalSetting alloc] init];
        self.statusManager = [[StatusManager alloc] init];
    }
    return self;
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

- (void)updateUserInfo
{
    [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"user/get_related_info" method:REQUEST_GET type:REQUEST_REFRESH withParams:nil observer:self completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
         [self parseData:responseObject];
    } fail:^(NSString *errMsg) {
        
    }];
}

- (void)updateUserInfoWithData:(TNDataWrapper *)userWrapper
{
    [self.userData.userInfo parseData:userWrapper];
    [self save];
}

- (void)save
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];;
    NSData *userData = [NSKeyedArchiver archivedDataWithRootObject:self.userData];
    [userDefaults setObject:userData forKey:@"userData"];
    [userDefaults synchronize];
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
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];;
    [userDefaults removeObjectForKey:@"userData"];
    [userDefaults synchronize];
}

- (void)requestNoDisturbingTime
{
    [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"setting/get_personal" method:REQUEST_GET type:REQUEST_REFRESH withParams:nil observer:nil completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
        self.personalSetting.startTime = [responseObject getStringForKey:@"no_disturbing_begin"];
        self.personalSetting.endTime = [responseObject getStringForKey:@"no_disturbing_end"];
        [self save];
    } fail:^(NSString *errMsg) {
        
    }];
}

- (void)setNoDisturbindTime
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.personalSetting.startTime forKey:@"no_disturbing_begin"];
    [params setValue:self.personalSetting.endTime forKey:@"no_disturbing_end"];
    [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"setting/set_personal" method:REQUEST_GET type:REQUEST_REFRESH withParams:params observer:nil completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
    } fail:^(NSString *errMsg) {
        
    }];
}

@end
