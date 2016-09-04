//
//  NotificationPreviewVC.h
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/7/30.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"
#import "NotificationSendEntity.h"
@interface NotificationPreviewVC : TNBaseViewController
@property (nonatomic, strong)NotificationSendEntity*    sendEntity;
@property (nonatomic, copy)void (^sendCallback)();
@end
