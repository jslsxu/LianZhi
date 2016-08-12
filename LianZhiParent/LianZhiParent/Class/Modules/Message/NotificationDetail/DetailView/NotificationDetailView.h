//
//  NotificationDetailView.h
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/7/30.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageDetailItem.h"
@interface NotificationDetailView : UIView{
    UIScrollView*       _scrollView;
}
@property (nonatomic, strong)MessageDetailItem*    notificationItem;
@end
