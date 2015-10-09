//
//  MineVC.h
//  LianZhiTeacher
//
//  Created by jslsxu on 15/8/12.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"

@interface UserInfoCell : TNTableViewCell
{
    AvatarView*     _avatarView;
    UILabel*        _nameLabel;
    UIImageView*    _genderView;
    UILabel*        _idLabel;
}
- (void)refresh;
@end

@interface MineVC : TNBaseViewController
{
    UITableView*    _tableView;
}
@end
