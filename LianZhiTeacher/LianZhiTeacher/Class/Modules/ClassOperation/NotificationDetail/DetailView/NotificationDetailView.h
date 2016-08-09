//
//  NotificationDetailView.h
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/7/30.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NotificationSendEntity.h"
@interface NotificationDetailView : UIView{
    UIScrollView*       _scrollView;
}
@property (nonatomic, strong)NotificationSendEntity*    notificationSendEntity;
@end
