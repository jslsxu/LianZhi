//
//  ContactStudentsVC.h
//  LianZhiTeacher
//
//  Created by jslsxu on 15/1/18.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"

@interface ContactStudentsVC : TNBaseViewController<UITableViewDataSource, UITableViewDelegate>
{
    UITableView*    _tableView;
}

@property (nonatomic, strong)ClassInfo *classInfo;
@end
