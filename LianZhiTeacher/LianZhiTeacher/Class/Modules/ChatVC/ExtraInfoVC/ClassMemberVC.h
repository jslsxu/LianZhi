//
//  ClassMemberVC.h
//  LianZhiParent
//
//  Created by jslsxu on 15/9/14.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"

@interface UserGroup : TNBaseObject
@property (nonatomic, copy)NSString *childID;
@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *indexkey;
@property (nonatomic, strong)NSArray *users;
@property (nonatomic, strong)NSArray *labelArray;
- (void)addGroup:(UserGroup *)userGroup;
@end

@interface MemberSectionHeader : UITableViewHeaderFooterView
{
    UILabel*    _titleLabel;
}
@property (nonatomic, copy)NSString *title;
@end


@interface MemberCell : TNTableViewCell
{
    AvatarView* _avatarView;
    UILabel*    _nameLabel;
//    UIButton*   _chatButton;
    UIView*     _sepLine;
}
@property(nonatomic, readonly)UIButton* chatButton;
@property (nonatomic, strong)UserInfo *userInfo;
@property (nonatomic, copy)NSString *label;
@end

@interface ClassMemberVC : TNBaseViewController
{
    UITableView*    _tableView;
}
@property (nonatomic, copy)NSString *classID;
@property (nonatomic, copy)NSString *groupID;
@property (nonatomic, copy)void (^atCallback)(UserInfo *user);
@property (nonatomic, copy)void (^cancelCallback)();
@end
