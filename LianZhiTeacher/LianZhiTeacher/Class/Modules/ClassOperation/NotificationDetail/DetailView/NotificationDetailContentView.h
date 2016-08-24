//
//  NotificationDetailContentView.h
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/7/30.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NotificationSendEntity.h"
@interface NotificationDetailContentView : UIView
@property (nonatomic, strong)NotificationItem *notificationItem;
@property (nonatomic, strong)NotificationSendEntity *sendEntity;
@end
