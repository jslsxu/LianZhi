//
//  SettingsVC.h
//  LianZhiParent
//
//  Created by jslsxu on 14/12/18.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"
#import "SettingItemCell.h"
#import "AboutVC.h"
#import "ContactServiceVC.h"
#import "PersonalSettingVC.h"
#import "PersonalInfoVC.h"
#import "RelatedInfoVC.h"
@interface SettingsVC : TNBaseViewController<UITableViewDelegate, UITableViewDataSource>
{
    UITableView*        _tableView;
    NSMutableArray*     _settingItems;
}
@end
