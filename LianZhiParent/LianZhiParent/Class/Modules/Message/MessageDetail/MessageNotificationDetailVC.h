//
//  MessageNotificationDetailVC.h
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/8/8.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"
#import "MessageDetailModel.h"
@interface MessageNotificationDetailVC : TNBaseViewController
@property (nonatomic, strong)MessageDetailItem* messageDetailItem;
@property (nonatomic, copy)void (^deleteSuccessCallback)(MessageDetailItem* messageDetailItem);
@end
