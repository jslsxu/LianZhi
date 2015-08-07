//
//  ContactServiceVC.h
//  LianZhiParent
//
//  Created by jslsxu on 15/1/28.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"

@interface ContactServiceItemCell : BGTableViewCell
{
    UILabel*        _titleLabel;
    UIImageView*    _arrow;
}

@property (nonatomic, copy)NSString *title;
@end

@interface ContactServiceVC : TNBaseViewController<UITableViewDataSource, UITableViewDelegate>
{
    NSArray*        _titleArray;
    UITableView*    _tableView;
}

@end
