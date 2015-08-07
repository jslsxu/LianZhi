//
//  SettingsVC.h
//  LianZhiParent
//
//  Created by jslsxu on 14/12/18.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"
#import "SettingItemCell.h"
#import "ChildrenInfoVC.h"
#import "RelatedInfoVC.h"
#import "PersonalSettingVC.h"
#import "ContactServiceVC.h"
#import "AboutVC.h"

@interface SettingsVC : TNBaseViewController<UITableViewDelegate, UITableViewDataSource>
{
    UITableView*        _tableView;
    NSMutableArray*     _settingItems;
}
@end
