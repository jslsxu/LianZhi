//
//  NotificationToAllVC.h
//  LianZhiTeacher
//
//  Created by jslsxu on 15/1/30.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"

@interface NotificationItem : TNModelItem
@property (nonatomic, copy)NSString *groupID;
@property (nonatomic, copy)NSString *groupName;
@property (nonatomic, strong)NSArray *subItems;
@property (nonatomic, copy)NSString *comment;
@property (nonatomic, assign)BOOL selected;
@property (nonatomic, assign)BOOL canSelected;
@end

@interface NotificationCell : TNTableViewCell
{
    UIView* _sepLine;
}
@property (nonatomic, strong)NotificationItem *notificationItem;
@end

@interface NotificationToAllVC : TNBaseViewController<UITableViewDataSource, UITableViewDelegate>
{
    UITableView* _tableView;
    NSMutableArray* _latestArray;
}
@end
