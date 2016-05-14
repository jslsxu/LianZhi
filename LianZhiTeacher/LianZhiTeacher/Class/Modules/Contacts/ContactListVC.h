//
//  ContactListVC.h
//  LianZhiParent
//
//  Created by jslsxu on 14/12/17.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "TNBaseTableViewController.h"
#import "ContactItemCell.h"
#import "ContactModel.h"
@interface ContactListHeaderView : UIView
{
    UILabel*    _titleLabel;
}

@end


@interface ContactListVC : TNBaseViewController<UITableViewDataSource, UITableViewDelegate>
{
    UIView*             _headerView;
    UISegmentedControl *_segCtrl;
    UITableView*    _classesTableView;
    UITableView*    _studentsTableView;
    UITableView*    _teacherTableView;
    ContactModel*   _contactModel;
}
@end
