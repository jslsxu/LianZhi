//
//  NotificationPreviewView.h
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/8/10.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NotificationSendEntity.h"
@interface NotificationPreviewView : UIView{
        UIScrollView*       _scrollView;
}
@property (nonatomic, strong)NotificationSendEntity*    notificationSendEntity;
@end
