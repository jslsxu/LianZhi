//
//  HomeWorkVC.h
//  LianZhiTeacher
//
//  Created by jslsxu on 15/10/7.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"
@interface HomeWorkVC : TNBaseViewController
{
    UIView*     _headerView;
    UIButton*   _addButton;
    UIView*     _typeView;
    UILabel*    _courseLabel;
    UIView*     _contentView;
    UITableView*    _tableView;
    UILabel*    _hintLabel;
}
@end
