//
//  SwitchClassVC.h
//  LianZhiParent
//
//  Created by jslsxu on 15/9/11.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"

@interface ClassItemCell : TNTableViewCell
{
    LogoView*   _logoView;
    UILabel*    _nameLabel;
    UIView*     _sepLine;
}
@property (nonatomic, strong)ClassInfo *classInfo;
@end

@interface SwitchClassVC : TNBaseViewController<UITableViewDataSource, UITableViewDelegate>
{
    UITableView*    _tableView;
}
@property (nonatomic, strong)ClassInfo *classInfo;
@property (nonatomic, copy)void (^completion)(ClassInfo *classInfo);
@end
