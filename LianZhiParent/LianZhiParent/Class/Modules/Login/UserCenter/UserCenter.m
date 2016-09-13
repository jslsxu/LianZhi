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
    if(configWrapper.count > 0)
    {
        LogConfig *config = [[LogConfig alloc] init];
        [config parseData:configWrapper];
        [self setConfig:config];
    }
    self.curChildIndex = 0;
    TNDataWrapper *userWrapper = [dataWrapper getDataWrapperForKey:@"user"];
    if(userWrapper)
    {
        UserInfo *userInfo = [[UserInfo alloc] init];
        [userInfo parseData:userWrapper];
        [self setUserInfo:userInfo];
    }

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
            return [childInfo1.uid compare:childInfo2.uid];
        }];
        self.children = childrenArray;
    }
}

- (void)updateChildren:(TNDataWrapper *)childrenWrapper{
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
            return [childInfo1.uid compare:childInfo2.uid];
        }];
        self.children = childrenArray;
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
    [[LZKVStorage applicationKVStorage] saveStorageValue:nil forKey:kUserDataStorageKey];
}

- (ChildInfo *)curChild
{
    if( self.userData.curChildIndex < self.userData.children.count)
        return self.userData.children[self.userData.curChildIndex];
    return nil;
}

- (void)setCurChild:(ChildInfo *)curChild
{
    NSInteger index = -1;
    for (NSInteger i = 0; i < self.userData.children.count; i++)
    {
        ChildInfo *child = self.userData.children[i];
        if([curChild.uid isEqualToString:child.uid])
        {
            index = i;
        }
    }
    if(index >=0 && index < self.userData.children.count)
    {
        [self.userData setCurChildIndex:index];
        [[NSNotificationCenter defaultCenter] postNotificationName:kUserCenterChangedCurChildNotification object:self userInfo:nil];
        [self save];
    }
}
- (void)updateUserInfoWithData:(TNDataWrapper *)userWrapper{
    [self.userData.userInfo parseData:userWrapper];
    [self save];
    
}

- (void)updateChildren
{
    if(!self.isLoadingContacts){
        self.isLoadingContacts = YES;
        [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"user/get_related_info" method:REQUEST_GET type:REQUEST_REFRESH withParams:nil observer:self completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
            self.isLoadingContacts = NO;
            if(responseObject.count > 0)
            {
                TNDataWrapper *childrenWrapper = [responseObject getDataWrapperForKey:@"children"];
                [self.userData updateChildren:childrenWrapper];
                [self save];
                [[NSNotificationCenter defaultCenter] postNotificationName:kUserInfoChangedNotification object:nil];
            }
        } fail:^(NSString *errMsg) {
            self.isLoadingContacts = NO;
            [[NSNotificationCenter defaultCenter] postNotificationName:kUserInfoChangedNotification object:nil];
        }];
    }
}


- (void)save
{
    [[LZKVStorage applicationKVStorage] saveStorageValue:self.userData forKey:kUserDataStorageKey];
}

- (void)requestNoDisturbingTime
{
    [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"setting/get_personal" method:REQUEST_GET type:REQUEST_REFRESH withParams:nil observer:nil completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
        self.personalSetting.startTime = [responseObject getStringForKey:@"no_disturbing_begin"];
        self.personalSetting.endTime = [responseObject getStringForKey:@"no_disturbing_end"];
        self.personalSetting.noDisturbing =[responseObject getBoolForKey:@"no_disturbing"];
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
