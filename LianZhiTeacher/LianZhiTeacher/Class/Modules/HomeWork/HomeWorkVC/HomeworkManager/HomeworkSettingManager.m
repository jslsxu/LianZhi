//
//  HomeworkSettingManager.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/10/19.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "HomeworkSettingManager.h"

@implementation HomeworkSetting

- (instancetype)init{
    self = [super init];
    if(self){
        self.homeworkNum = 5;
        self.sendSms = YES;
        
    }
    return self;
}

@end

@interface HomeworkSettingManager ()
@property (nonatomic, copy)NSString *userStoragePath;
@property (nonatomic, strong)HomeworkSetting *homeworkSetting;
@end

@implementation HomeworkSettingManager
+ (instancetype)sharedInstance{
    static HomeworkSettingManager *draftManager = nil;
    @synchronized (self) {
        NSString *storagePath = [NHFileManager localCurrentUserStoragePath];
        
        if ([storagePath isEqualToString:draftManager.userStoragePath]) {
            return draftManager;
        }
        
        draftManager = [[HomeworkSettingManager alloc] init];
        [draftManager setUserStoragePath:storagePath];
    }
    return draftManager;
}

- (instancetype)init{
    self = [super init];
    if(self){
        self.homeworkSetting = [[LZKVStorage userKVStorage] storageValueForKey:[self cacheKey]];
        if(!self.homeworkSetting){
            self.homeworkSetting = [[HomeworkSetting alloc] init];
        }
    }
    return self;
}

- (HomeworkSetting *)getHomeworkSetting{
    return self.homeworkSetting;
}

- (void)save{
    [[LZKVStorage userKVStorage] saveStorageValue:self.homeworkSetting forKey:[self cacheKey]];
}

- (NSString *)cacheKey{
    return @"HomeworkSetting";
}

@end
