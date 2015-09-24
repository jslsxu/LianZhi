//
//  NotificationTargetSelectVC.h
//  LianZhiTeacher
//
//  Created by jslsxu on 15/9/10.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"

@interface NotificationTargetCell : TNTableViewCell
{
    UIButton*   _checkButton;
    UILabel*    _nameLabel;
    UIView*     _sepLine;
}
@property (nonatomic, strong)ClassInfo *classInfo;
@property (nonatomic, readonly)UILabel *nameLabel;
@end

@interface NotificationGroupHeaderView : UIView
{
    UIButton*   _checkButton;
    UILabel*    _nameLabel;
}
@property (nonatomic, readonly)UILabel *nameLabel;
@end

typedef void(^Completion)(NSString *targetJson);

@interface NotificationTargetSelectVC : TNBaseViewController
{
    UISegmentedControl* _segmentControl;
    UITableView*        _tableView;
}
@property (nonatomic, copy)Completion completion;
@end
