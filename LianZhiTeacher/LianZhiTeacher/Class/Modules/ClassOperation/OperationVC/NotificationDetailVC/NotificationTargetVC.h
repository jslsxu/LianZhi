//
//  NotificationTargetVC.h
//  LianZhiTeacher
//
//  Created by jslsxu on 15/11/8.
//  Copyright © 2015年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"
#import "NotificationClassStudentsVC.h"
@interface NotificationTargetVC : TNBaseViewController<UITableViewDataSource, UITableViewDelegate>
{
    UITableView*    _tableView;
}
@property (nonatomic, copy)NSString *groupID;
@property (nonatomic, copy)NSArray  *selectedArray;
@end
