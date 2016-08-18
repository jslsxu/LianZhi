//
//  NotificationManager.h
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/8/14.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "TNBaseObject.h"

extern NSString *kNotificationManagerChangedNotification;
extern NSString *kNotificationSendSuccessNotification;
extern NSString *kNewNotificationToSend;
#define kSendingNotificationKey         @"SendingNotification"
#define kSendedNotificationKey          @"SendedNotification"
@interface NotificationManager : TNBaseObject
SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(NotificationManager)
@property (nonatomic, readonly)NSArray*    sendingNotificationArray;
- (void)addNotification:(NotificationSendEntity *)notificationSendEntity;
- (void)removeNotification:(NotificationSendEntity *)notificationSendEntity;
- (void)clearSendingList;
@end
