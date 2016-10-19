//
//  HomeworkSettingManager.h
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/10/19.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "TNBaseObject.h"

@interface HomeworkSetting : TNBaseObject
@property (nonatomic, assign)BOOL etype;
@property (nonatomic, assign)NSInteger homeworkNum;
@property (nonatomic, assign)BOOL sendSms;
@property (nonatomic, assign)BOOL replyEndOn;
@property (nonatomic, copy)NSString*    replyEndTime;
@end

@interface HomeworkSettingManager : TNBaseObject
+ (instancetype)sharedInstance;
- (HomeworkSetting *)getHomeworkSetting;
- (void)save;
@end
