//
//  ContactListVC.h
//  LianZhiParent
//
//  Created by jslsxu on 14/12/17.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "ContactItemCell.h"


@interface ContactListHeaderView : UITableViewHeaderFooterView
{
    LogoView*   _logoView;
    UILabel*    _classLabel;
    UILabel*    _schoolLabel;
    UILabel*    _numLabel;
    UIView*     _sepLine;
    UIButton*   _chatButton;
}
@property (nonatomic, strong)ClassInfo *classInfo;
@property (nonatomic, copy)void (^chatCallback)();
@property (nonatomic, copy)void (^expandCallback)();
@end

@interface ContactListVC : TNBaseViewController<UITableViewDataSource, UITableViewDelegate>
{
    UITableView*    _tableView;
}
@end
