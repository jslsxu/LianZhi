//
//  ContactListVC.h
//  LianZhiParent
//
//  Created by jslsxu on 14/12/17.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "ContactItemCell.h"

@interface ClassParentsCell : TNTableViewCell
{
    
}

@end

@interface ContactListHeaderView : UIView
{
    LogoView*   _logoView;
    UILabel*    _classLabel;
    UILabel*    _schoolLabel;
    UILabel*    _numLabel;
    UIView*     _sepLine;
    UIButton*   _chatButton;
}
@property (nonatomic, strong)ClassInfo *classInfo;

@end

@interface ContactListVC : TNBaseViewController<UITableViewDataSource, UITableViewDelegate>
{
    UITableView*    _tableView;
}
@end
