//
//  NotificationToAllVC.h
//  LianZhiTeacher
//
//  Created by jslsxu on 15/1/30.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"

@interface NotificationGroupItem : TNModelItem
@property (nonatomic, copy)NSString *groupID;
@property (nonatomic, copy)NSString *groupName;
@property (nonatomic, strong)NSArray *subItems;
@property (nonatomic, copy)NSString *comment;
@property (nonatomic, assign)BOOL selected;
@property (nonatomic, assign)BOOL canSelected;
@end

@interface NotificationGroupCell : BGTableViewCell
{
    UILabel*        _groupNameLabel;
    UILabel*        _commentLabel;
    UIImageView*    _checkBox;
}
@property (nonatomic, strong)NotificationGroupItem *groupItem;
@end

@interface NotificationToAllVC : TNBaseViewController<UITableViewDataSource, UITableViewDelegate>
{
    UITableView* _tableView;
}
@end
