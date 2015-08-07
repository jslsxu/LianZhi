//
//  PersonalSettingVC.h
//  LianZhiParent
//
//  Created by jslsxu on 15/1/16.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"

typedef void(^SwitchBlk)(BOOL on);

@interface PersonalSettingCell : BGTableViewCell
{
    UILabel*    _titleLabel;
    UISwitch*   _switch;
}
@property (nonatomic, readonly)UILabel* titleLabel;
@property (nonatomic, assign)BOOL isOn;
@property (nonatomic, copy)SwitchBlk switchBlk;

@end
@interface NoDisturbingCell : BGTableViewCell
{
    UILabel*    _titleLabel;
    UILabel*    _valueLabel;
}
@property (nonatomic, readonly)UILabel *titleLabel;
@property (nonatomic, readonly)UILabel *valueLabel;

@end

@interface PersonalSettingVC : TNBaseViewController<UITableViewDataSource, UITableViewDelegate>
{
    UITableView*        _tableView;
}
@end
