//
//  ConfimInfoVC.h
//  LianZhiParent
//
//  Created by jslsxu on 14/12/19.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"

@interface ConfimInfoVC : TNBaseViewController<UITableViewDataSource, UITableViewDelegate>
{
    UIView*         _headerView;
    UITableView*    _tableView;
    UIButton*       _reportButton;
}
@end
