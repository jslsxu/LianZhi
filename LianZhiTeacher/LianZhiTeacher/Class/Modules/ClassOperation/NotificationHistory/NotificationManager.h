//
//  NotificationManager.h
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/8/14.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "TNBaseObject.h"

extern NSString *kNotificationManagerChangedNotification;

@interface NotificationManager : TNBaseObject
SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(NotificationManager)

- (void)requestNotificationRecord;
@end
