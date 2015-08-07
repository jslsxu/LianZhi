//
//  UserCenter.m
//  LianZhiParent
//
//  Created by jslsxu on 15/1/9.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "UserCenter.h"
NSString *const kUserCenterChangedCurChildNotification = @"UserCenterChangedCurChildNotification";
NSString *const kUserInfoChangedNotification = @"UserInfoChangedNotification";
NSString *const kPersonalSettingChangedNotification = @"PersonalSettingChangedNotification";
NSString *const kChildInfoChangedNotification = @"ChildInfoChangedNotification";
#define kUserCenterCacheFile            @"lianzhiParentUser"

@implementation UserData
- (void)parseData:(TNDataWrapper *)dataWrapper
{
    TNDataWrapper *userWrapper = [dataWrapper getDataWrapperForKey:@"user"];
    if(userWrapper)
    {
        UserInfo *userInfo = [[UserInfo alloc] init];
        [userInfo parseData:userWrapper];
        [self setUserInfo:userInfo];
    }
    
    self.firstLogin = [dataWrapper getBoolForKey:@"first_login"];
    self.confirmed = [dataWrapper getBoolForKey:@"confirmed"];
    NSString *verify = [dataWrapper getStringForKey:@"verify"];
    if(verify.length > 0)
        self.accessToken = verify;
    
    TNDataWrapper *childrenWrapper = [dataWrapper getDataWrapperForKey:@"children"];
    if(childrenWrapper.count > 0)
    {
        NSMutableArray *childrenArray = [[NSMutableArray alloc] initWithCapacity:0];
        for (NSInteger i = 0; i < childrenWrapper.count; i++) {
            TNDataWrapper *childDataWrapper = [childrenWrapper getDataWrapperForIndex:i];
            ChildInfo *childInfo = [[ChildInfo alloc] init];
            [childInfo parseData:childDataWrapper];
            [childrenArray addObject:childInfo];
        }
        [childrenArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            ChildInfo *childInfo1 = (ChildInfo *)obj1;
            ChildInfo *childInfo2 = (ChildInfo *)obj2;
            return [childInfo1.birthday compare:childInfo2.birthday];
        }];
        self.children = childrenArray;
    }
    
    
    TNDataWrapper *configWrapper = [dataWrapper getDataWrapperForKey:@"config"];
    if(configWrapper.count > 0)
    {
        LogConfig *config = [[LogConfig alloc] init];
        [config parseData:configWrapper];
        [self setConfig:config];
    }

}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super init])
    {
        self.userInfo = [aDecoder decodeObjectForKey:@"user"];
        self.firstLogin = [aDecoder decodeBoolForKey:@"first_login"];
        self.accessToken = [aDecoder decodeObjectForKey:@"verify"];
        self.config = [aDecoder decodeObjectForKey:@"config"];
        NSArray *childrenArray = [aDecoder decodeObjectForKey:@"children"];
        self.children = [[NSMutableArray alloc] initWithArray:childrenArray];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.userInfo forKey:@"user"];
    [aCoder encodeBool:self.firstLogin forKey:@"first_login"];
    [aCoder encodeObject:self.accessToken forKey:@"verify"];
    [aCoder encodeObject:self.config forKey:@"config"];
    [aCoder encodeObject:self.children forKey:@"children"];
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
        else
            self.userData = [[UserData alloc] init];
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

- (UserInfo *)userInfo
{
    return self.userData.userInfo;
}

- (NSArray *)children
{
    return self.userData.children;
}

- (BOOL)hasLogin
{
    return (self.userData.accessToken.length > 0);
}

- (void)logout
{
    self.userData = nil;
    self.statusManager = [[StatusManager alloc] init];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];;
    [userDefaults removeObjectForKey:@"userData"];
    [userDefaults synchronize];
}

- (ChildInfo *)curChild
{
    if(self.userData.children.count >= 1)
        return self.userData.children[0];
    return nil;
}

- (void)setCurChild:(ChildInfo *)curChild
{
    NSInteger index = [self.userData.children indexOfObject:curChild];
    if(index != 0)
    {
        [self.userData.children removeObject:curChild];
        [self.userData.children insertObject:curChild atIndex:0];
        [[NSNotificationCenter defaultCenter] postNotificationName:kUserCenterChangedCurChildNotification object:self userInfo:nil];
        [self save];
    }
}

- (void)updateUserInfo:(TNDataWrapper *)userWrapper
{
    [self.userData.userInfo parseData:userWrapper];
    [self save];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kUserInfoChangedNotification object:nil];
}

- (void)updateChildData:(TNDataWrapper *)childWrapper
{
    
}

- (void)save
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];;
    NSData *userData = [NSKeyedArchiver archivedDataWithRootObject:self.userData];
    [userDefaults setObject:userData forKey:@"userData"];
    [userDefaults synchronize];
}


@end
