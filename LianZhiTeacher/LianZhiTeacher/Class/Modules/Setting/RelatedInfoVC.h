//
//  RelatedInfoVC.h
//  LianZhiTeacher
//
//  Created by jslsxu on 15/2/5.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"

@interface RelatedSchoolCell : UITableViewCell
{
    UIImageView*    _bgImageView;
    LogoView*       _logoView;
    UILabel*        _nameLabel;
}
@property (nonatomic, strong)SchoolInfo *schoolInfo;

@end

@interface RelatedClassCell : UITableViewCell
{
    UIImageView*    _bgImageView;
    LogoView*       _logoView;
    UILabel*        _nameLabel;
}
@property (nonatomic, assign)TableViewCellType cellType;
@property (nonatomic, strong)ClassInfo *classInfo;
@end

@interface RelatedInfoVC : TNBaseViewController<UITableViewDataSource, UITableViewDelegate>
{
    UIView*         _headerView;
    UITableView*    _tableView;
}
@end
