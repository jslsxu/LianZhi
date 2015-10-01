//
//  NotificationDetailVC.h
//  LianZhiTeacher
//
//  Created by jslsxu on 15/10/1.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"
#import "NotificationToAllVC.h"
@interface NotificationDetailVC : TNBaseViewController<UITableViewDataSource, UITableViewDelegate>
{
    UIView*         _headerView;
    UITableView*    _tableView;
}
@property (nonatomic, strong)NotificationItem *notificationItem;
@end
