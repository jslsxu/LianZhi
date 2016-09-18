//
//  ContactItemCell.m
//  LianZhiParent
//
//  Created by jslsxu on 14/12/18.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "ContactItemCell.h"

@implementation ClassItemCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        _logoView = [[LogoView alloc] initWithFrame:CGRectMake(15, (self.height - 36) / 2, 36, 36)];
        [self addSubview:_logoView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_logoView.right + 15, 0, self.width - _logoView.right - 30, self.height)];
        [_nameLabel setBackgroundColor:[UIColor clearColor]];
        [_nameLabel setTextColor:[UIColor colorWithHexString:@"2c2c2c"]];
        [_nameLabel setFont:[UIFont systemFontOfSize:14]];
        [self addSubview:_nameLabel];
        
        _redDot = [[UIView alloc] initWithFrame:CGRectMake(self.width - 40, (self.height - 8) / 2, 8, 8)];
        [_redDot setBackgroundColor:[UIColor colorWithHexString:@"F0003A"]];
        [_redDot.layer setCornerRadius:4];
        [_redDot.layer setMasksToBounds:YES];
        [self addSubview:_redDot];
        [_redDot setHidden:YES];

        _sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, 44 - 0.5, self.width, 0.5)];
        [_sepLine setBackgroundColor:kSepLineColor];
        [self addSubview:_sepLine];
        
//        _chatButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_chatButton setFrame:CGRectMake(self.width - 40 - 10, (self.height - 30) / 2, 40, 30)];
//        [_chatButton setImage:[UIImage imageNamed:@"ChatButtonNormal"] forState:UIControlStateNormal];
//        [_chatButton setImage:[UIImage imageNamed:@"ChatButtonHighlighted"] forState:UIControlStateHighlighted];
//        [self addSubview:_chatButton];
    }
    return self;
}

- (void)setClassInfo:(ClassInfo *)classInfo
{
    _classInfo = classInfo;
    [_logoView sd_setImageWithURL:[NSURL URLWithString:_classInfo.logo]];
    [_nameLabel setText:_classInfo.name];
}

@end

@implementation ContactItemCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        _avatar = [[AvatarView alloc] initWithFrame:CGRectMake(0, 0, 36, 36)];
        [self addSubview:_avatar];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_nameLabel setBackgroundColor:[UIColor clearColor]];
        [_nameLabel setTextColor:[UIColor colorWithHexString:@"2c2c2c"]];
        [_nameLabel setFont:[UIFont systemFontOfSize:14]];
        [self addSubview:_nameLabel];
        
        _commentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_commentLabel setBackgroundColor:[UIColor clearColor]];
        [_commentLabel setTextColor:[UIColor colorWithRed:160 / 255.0 green:160 / 255.0 blue:160 / 255.0 alpha:1.f]];
        [_commentLabel setFont:[UIFont systemFontOfSize:13]];
        [self addSubview:_commentLabel];
        
        _phoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_phoneButton addTarget:self action:@selector(onPhoneClicked) forControlEvents:UIControlEventTouchUpInside];
        [_phoneButton setImage:[UIImage imageNamed:@"contact_telephone"] forState:UIControlStateNormal];
        [_phoneButton setImage:[UIImage imageNamed:@"contact_telephone_disabled"] forState:UIControlStateDisabled];
        [self addSubview:_phoneButton];
        
        _chatButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_chatButton addTarget:self action:@selector(onChatClicked) forControlEvents:UIControlEventTouchUpInside];
        [_chatButton setImage:[UIImage imageNamed:@"contact_chat"] forState:UIControlStateNormal];
        [_chatButton setImage:[UIImage imageNamed:@"contact_chat_disabled"] forState:UIControlStateDisabled];
        [self addSubview:_chatButton];
        
        _sepLine = [[UIView alloc] initWithFrame:CGRectZero];
        [_sepLine setBackgroundColor:[UIColor colorWithHexString:@"eaeaea"]];
        [self addSubview:_sepLine];
    }
    return self;
}


- (void)setUserInfo:(UserInfo *)userInfo
{
    _userInfo = userInfo;
    [_avatar setCenter:CGPointMake(15 + _avatar.width / 2, self.height / 2)];
    NSInteger buttonWidth = 30;
    [_phoneButton setFrame:CGRectMake(self.width - 25 - buttonWidth, 0, buttonWidth, self.height)];
    [_chatButton setFrame:CGRectMake(_phoneButton.left - 5 - buttonWidth, 0, buttonWidth, self.height)];
    if([_userInfo isKindOfClass:[TeacherGroup class]])
    {
        TeacherGroup *group = (TeacherGroup *)_userInfo;
        [_avatar sd_setImageWithURL:[NSURL URLWithString:group.logo] placeholderImage:[UIImage imageNamed:@"NoLogoDefault"]];
        [_avatar setStatus:nil];
        [_commentLabel setText:nil];
        TeacherGroup *teacherGroup = (TeacherGroup *)userInfo;
        [_nameLabel setText:teacherGroup.groupName];
        [_nameLabel sizeToFit];
        [_nameLabel setFrame:CGRectMake(_avatar.right + 15, (self.height - _nameLabel.height) / 2, MIN(_nameLabel.width, self.width - _nameLabel.left - 10), _nameLabel.height)];
        [_chatButton setHidden:YES];
        [_phoneButton setHidden:YES];
    }
    else
    {
        [_avatar setStatus:_userInfo.actived ? nil : @"未下载"];
        [_avatar sd_setImageWithURL:[NSURL URLWithString:userInfo.avatar] placeholderImage:[UIImage imageNamed:(@"NoAvatarDefault.png")]];
        [_nameLabel setText:userInfo.name];
        [_nameLabel sizeToFit];
        [_nameLabel setFrame:CGRectMake(_avatar.right + 15, (self.height - _nameLabel.height) / 2, MIN(_nameLabel.width, self.width - _nameLabel.left - 10), _nameLabel.height)];
        
        if([userInfo isKindOfClass:[TeacherInfo class]] || [userInfo isKindOfClass:[FamilyInfo class]])
        {
            TeacherInfo *teacher = (TeacherInfo *)userInfo;
            [_commentLabel setText:teacher.title];
            [_commentLabel sizeToFit];
            [_commentLabel setOrigin:CGPointMake(_nameLabel.right + 15, (self.height - _commentLabel.height) / 2)];
            [_chatButton setEnabled:_userInfo.actived];
            [_chatButton setHidden:NO];
            [_phoneButton setEnabled:_userInfo.mobile.length > 0];
            [_phoneButton setHidden:NO];
        }
        else
        {
            StudentInfo *studentInfo = (StudentInfo *)userInfo;
            [_commentLabel setText:[NSString stringWithFormat:@"(%ld位家长)",studentInfo.family.count]];
            [_commentLabel sizeToFit];
            [_commentLabel setOrigin:CGPointMake(_nameLabel.right + 15, (self.height - _commentLabel.height) / 2)];
            [_chatButton setHidden:YES];
            [_phoneButton setHidden:YES];
        }
    }
    [_sepLine setFrame:CGRectMake(_avatar.right + 10, self.height - kLineHeight, self.width - (_avatar.right + 10), kLineHeight)];
}

- (void)onChatClicked{
    if(self.chatCallback){
        self.chatCallback();
    }
}

- (void)onPhoneClicked{
    if(self.telephoneCallback){
        self.telephoneCallback();
    }
}
@end
