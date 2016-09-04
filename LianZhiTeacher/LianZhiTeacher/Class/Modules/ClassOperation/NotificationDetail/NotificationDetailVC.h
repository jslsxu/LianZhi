//
//  NotificationDetailVC.h
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/7/29.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"
#import "MessageDetailModel.h"
#import "NotificationItem.h"

extern NSString *const kNotificationReadNumChangedNotification;

@interface NotificationDetailVC : TNBaseViewController
@property (nonatomic, copy)NSString *notificationID;
@property (nonatomic, copy)void (^deleteCallback)(NSString *notificationID);
@end
