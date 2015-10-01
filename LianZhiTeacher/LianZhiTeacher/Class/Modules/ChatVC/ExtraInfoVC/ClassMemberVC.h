//
//  ClassMemberVC.h
//  LianZhiParent
//
//  Created by jslsxu on 15/9/14.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"

@interface MemberCell : TNTableViewCell
{
    AvatarView* _avatarView;
    UILabel*    _nameLabel;
    UIButton*   _chatButton;
    UIView*     _sepLine;
}
@property(nonatomic, readonly)UIButton* chatButton;
@property (nonatomic, strong)UserInfo *userInfo;
@end

@interface ClassMemberVC : TNBaseViewController
{
    UITableView*    _tableView;
}
@property (nonatomic, copy)NSString *classID;
@end
