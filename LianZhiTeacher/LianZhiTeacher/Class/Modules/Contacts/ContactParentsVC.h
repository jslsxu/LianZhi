//
//  ContactParentsVC.h
//  LianZhiTeacher
//
//  Created by jslsxu on 15/1/18.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"
#import "ContactModel.h"
#import "ContactItemCell.h"
@interface ContactParentsVC : TNBaseViewController<UITableViewDataSource, UITableViewDelegate>
{
    UITableView*    _tableView;
}
@property (nonatomic, assign)BOOL presentedByClassOperation;
@property (nonatomic, strong)StudentInfo *studentInfo;
@end
