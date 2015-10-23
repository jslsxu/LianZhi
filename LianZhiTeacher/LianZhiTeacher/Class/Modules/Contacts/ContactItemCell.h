//
//  ContactItemCell.h
//  LianZhiParent
//
//  Created by jslsxu on 14/12/18.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "TNTableViewCell.h"
#import "SchoolInfo.h"
@interface ClassItemCell : TNTableViewCell
{
    LogoView*   _logoView;
    UILabel*    _nameLabel;
    UIView*     _sepLine;
    UIButton*   _chatButton;
}
@property (nonatomic, strong)ClassInfo *classInfo;
@property (nonatomic, readonly)UIButton *chatButton;
@end


@interface ContactItemCell : TNTableViewCell
{
    AvatarView*  _avatar;
    UILabel*            _nameLabel;
    UILabel*            _commentLabel;
    UIImageView*        _genderImageView;
    UIView*             _sepLine;
    UIButton*           _chatButton;
}
@property (nonatomic, strong)UserInfo *userInfo;
@end
