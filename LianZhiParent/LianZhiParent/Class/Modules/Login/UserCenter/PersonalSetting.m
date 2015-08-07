//
//  PersonalSetting.m
//  LianZhiParent
//
//  Created by jslsxu on 15/2/9.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "PersonalSetting.h"

NSString *const kPersonalSettingKey = @"PersonalSettingKey";
@implementation PersonalSetting

- (id)init
{
    self = [super init];
    if(self)
    {
        self.wifiSend = YES;
        self.autoSave = YES;
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if(self)
    {
        self.wifiSend = [aDecoder decodeBoolForKey:@"only_wifi_photo"];
        self.autoSave = [aDecoder decodeBoolForKey:@"auto_save"];
        self.soundOn = [aDecoder decodeBoolForKey:@"sound"];
        self.shakeOn = [aDecoder decodeBoolForKey:@"shake"];
        self.noDisturbing = [aDecoder decodeBoolForKey:@"no_disturbing"];
        self.startTime = [aDecoder decodeObjectForKey:@"no_disturbing_begin"];
        self.endTime = [aDecoder decodeObjectForKey:@"no_disturbing_end"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeBool:self.wifiSend forKey:@"only_wifi_photo"];
    [aCoder encodeBool:self.autoSave forKey:@"auto_save"];
    [aCoder encodeBool:self.soundOn forKey:@"sound"];
    [aCoder encodeBool:self.shakeOn forKey:@"shake"];
    [aCoder encodeBool:self.noDisturbing forKey:@"no_disturbing"];
    [aCoder encodeObject:self.startTime forKey:@"no_disturbing_begin"];
    [aCoder encodeObject:self.endTime forKey:@"no_disturbing_end"];
}

- (void)save
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];;
    NSData *userData = [NSKeyedArchiver archivedDataWithRootObject:self];
    [userDefaults setObject:userData forKey:kPersonalSettingKey];
    [userDefaults synchronize];
}

@end
