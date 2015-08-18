//
//  PersonalSettingVC.h
//  LianZhiParent
//
//  Created by jslsxu on 15/1/16.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"

typedef void(^SwitchBlk)(BOOL on);

@interface PersonalSettingCell : UITableViewCell
{
    UILabel*    _titleLabel;
    UISwitch*   _switchCtl;
    UILabel*    _extraLabel;
}
@property (nonatomic, readonly)UILabel* titleLabel;
@property (nonatomic, readonly)UISwitch *switchCtl;
@property (nonatomic, readonly)UILabel* extraLabel;
@property (nonatomic, assign)BOOL isOn;
@property (nonatomic, copy)SwitchBlk switchBlk;

@end

@interface PersonalSettingVC : TNBaseViewController<UITableViewDataSource, UITableViewDelegate>
{
    UITableView*        _tableView;
}
@end
