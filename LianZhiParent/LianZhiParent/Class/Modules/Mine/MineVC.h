//
//  MineVC.h
//  LianZhiParent
//
//  Created by jslsxu on 15/8/8.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"

@interface USerInfoCell : UITableViewCell
{
    AvatarView*     _avatarView;
    UILabel*        _nameLabel;
    UIImageView*    _genderView;
    UILabel*        _idLabel;
}
- (void)refresh;
@end

@interface MineCell : UITableViewCell
@property (nonatomic, assign)BOOL hasNew;
- (void)setimage:(UIImage *)image title:(NSString *)title;
@end

@interface MineVC : TNBaseViewController<UITableViewDataSource, UITableViewDelegate>
{
    UITableView*    _tableView;
}
@end
