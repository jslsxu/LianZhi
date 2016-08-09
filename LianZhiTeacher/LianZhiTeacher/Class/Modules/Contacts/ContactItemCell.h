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
    UIView*     _redDot;
//    UIButton*   _chatButton;
}
@property (nonatomic, readonly)UIView *redDot;
@property (nonatomic, strong)ClassInfo *classInfo;
@property (nonatomic, readonly)UIButton *chatButton;
@end


@interface ContactItemCell : TNTableViewCell
{
    AvatarView*  _avatar;
    UILabel*            _nameLabel;
    UILabel*            _commentLabel;
    UIView*             _sepLine;
    UIButton*           _chatButton;
    UIButton*           _phoneButton;
}
@property (nonatomic, strong)UserInfo *userInfo;
@property (nonatomic, copy)void (^chatCallback)();
@property (nonatomic, copy)void (^telephoneCallback)();
@end
