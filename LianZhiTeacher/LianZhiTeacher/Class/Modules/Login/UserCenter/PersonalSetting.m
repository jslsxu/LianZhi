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
        self.soundOn = YES;
        self.shakeOn = YES;
        self.wifiSend = YES;
        self.autoSave = YES;
    }
    return self;
}


- (void)save
{
    [[LZKVStorage userKVStorage] saveStorageValue:self forKey:kPersonalSettingKey];
}

@end
