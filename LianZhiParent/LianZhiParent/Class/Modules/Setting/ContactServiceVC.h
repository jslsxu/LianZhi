//
//  ContactServiceVC.h
//  LianZhiParent
//
//  Created by jslsxu on 15/1/28.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"

@interface ContactServiceCell : UITableViewCell
{
    UIView*     _contentView;
    UILabel*    _nameLabel;
}
@property (nonatomic, readonly)UILabel *nameLabel;
@end

@interface ContactServiceVC : TNBaseViewController<UITableViewDataSource, UITableViewDelegate>
{
    NSArray*        _titleArray;
    UITableView*    _tableView;
}

@end
