//
//  ExchangeSchoolVC.h
//  LianZhiTeacher
//
//  Created by jslsxu on 15/2/5.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"
#import "MessageGroupListModel.h"
#import "PreviewMessageVC.h"
@interface SchoolInfoCell : UITableViewCell
{
    LogoView*       _logoView;
    UILabel*        _nameLabel;
    UILabel*        _statusLabel;
    UIImageView*    _arrowImage;
    UIView*         _sepLine;
}
@property (nonatomic, strong)SchoolInfo *schoolInfo;
@property (nonatomic, assign)BOOL isCurSchool;
@end

@interface ExchangeSchoolVC : TNBaseViewController<UITableViewDataSource, UITableViewDelegate>
{
    UITableView*    _tableView;
}
@end
