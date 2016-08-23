//
//  PersonalSetting.h
//  LianZhiParent
//
//  Created by jslsxu on 15/2/9.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "TNModelItem.h"
extern NSString *const kPersonalSettingKey;
@interface PersonalSetting : TNModelItem
@property (nonatomic, assign)BOOL earPhone;
@property (nonatomic, assign)BOOL wifiSend;
@property (nonatomic, assign)BOOL autoSave;
@property (nonatomic, assign)BOOL soundOn;
@property (nonatomic, assign)BOOL shakeOn;
@property (nonatomic, assign)BOOL noDisturbing;
@property (nonatomic, copy)NSString *startTime;
@property (nonatomic ,copy)NSString *endTime;
- (void)save;
@end
