//
//  ClassMemberVC.h
//  LianZhiParent
//
//  Created by jslsxu on 15/9/14.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"

@interface MemberItem : TNBaseObject
@property (nonatomic, copy)NSString *toObjid;
@property (nonatomic, strong)UserInfo *userInfo;
@property (nonatomic, copy)NSString *label;

@end

@interface  SectionGroup: TNBaseObject
@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *indexkey;
@property (nonatomic, copy)NSArray *memberArray;
- (void)addGroup:(SectionGroup *)sectionGroup;
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
@property (nonatomic, copy)void (^atCallback)(UserInfo *user);
@property (nonatomic, copy)void (^cancelCallback)();
@end
