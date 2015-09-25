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
        [_nameLabel setTextColor:[UIColor darkGrayColor]];
        [_nameLabel setFont:[UIFont systemFontOfSize:15]];
        [self addSubview:_nameLabel];

        _sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, 44 - 0.5, self.width, 0.5)];
        [_sepLine setBackgroundColor:[UIColor colorWithRed:240 / 255.0 green:240 / 255.0 blue:240 / 255.0 alpha:1.f]];
        [self addSubview:_sepLine];
        
        _chatButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_chatButton setFrame:CGRectMake(self.width - 40 - 10, (self.height - 30) / 2, 40, 30)];
        [_chatButton addTarget:self action:@selector(onChatClicked) forControlEvents:UIControlEventTouchUpInside];
        [_chatButton setImage:[UIImage imageNamed:@"ChatButtonNormal"] forState:UIControlStateNormal];
        [_chatButton setImage:[UIImage imageNamed:@"ChatButtonHighlighted"] forState:UIControlStateHighlighted];
        [self addSubview:_chatButton];
    }
    return self;
}

- (void)setClassInfo:(ClassInfo *)classInfo
{
    _classInfo = classInfo;
    [_logoView setImageWithUrl:[NSURL URLWithString:_classInfo.logoUrl]];
    [_nameLabel setText:_classInfo.className];
}

- (void)onChatClicked
{
    JSMessagesViewController *chatVC = [[JSMessagesViewController alloc] init];
    [chatVC setTargetID:self.classInfo.classID];
    [chatVC setChatType:ChatTypeClass];
    [ApplicationDelegate popAndPush:chatVC];
}

@end

@implementation ContactItemCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        _avatar = [[MSCircleImageView alloc] initWithFrame:CGRectMake(0, 0, 36, 36)];
        [_avatar setBorderColor:[UIColor whiteColor]];
        [_avatar setBorderWidth:2];
        [_avatar setCenter:CGPointMake(15 + _avatar.width / 2, self.height / 2)];
        [self addSubview:_avatar];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_nameLabel setBackgroundColor:[UIColor clearColor]];
        [_nameLabel setTextColor:[UIColor lightGrayColor]];
        [_nameLabel setFont:[UIFont systemFontOfSize:16]];
        [self addSubview:_nameLabel];
        
        _commentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_commentLabel setBackgroundColor:[UIColor clearColor]];
        [_commentLabel setTextColor:[UIColor colorWithRed:160 / 255.0 green:160 / 255.0 blue:160 / 255.0 alpha:1.f]];
        [_commentLabel setFont:[UIFont systemFontOfSize:14]];
        [self addSubview:_commentLabel];
        
        _genderImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self addSubview:_genderImageView];
        
        _chatButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_chatButton setFrame:CGRectMake(self.width - 40 - 10, (self.height - 30) / 2, 40, 30)];
        [_chatButton addTarget:self action:@selector(onChatClicked) forControlEvents:UIControlEventTouchUpInside];
        [_chatButton setImage:[UIImage imageNamed:@"ChatButtonNormal"] forState:UIControlStateNormal];
        [_chatButton setImage:[UIImage imageNamed:@"ChatButtonHighlighted"] forState:UIControlStateHighlighted];
        [self addSubview:_chatButton];
        
        _sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, 44 - 0.5, self.width, 0.5)];
        [_sepLine setBackgroundColor:[UIColor colorWithRed:240 / 255.0 green:240 / 255.0 blue:240 / 255.0 alpha:1.f]];
        [self addSubview:_sepLine];
    }
    return self;
}


- (void)setUserInfo:(UserInfo *)userInfo
{
    _userInfo = userInfo;
    [_avatar setImageWithUrl:[NSURL URLWithString:userInfo.avatar] placeHolder:[UIImage imageNamed:(@"NoAvatarDefault.png")]];
    
    [_nameLabel setText:userInfo.name];
    [_nameLabel sizeToFit];
    [_nameLabel setFrame:CGRectMake(_avatar.right + 15, (self.height - _nameLabel.height) / 2, MIN(_nameLabel.width, _chatButton.left - _nameLabel.left - 10), _nameLabel.height)];
    
    if([userInfo isKindOfClass:[TeacherInfo class]])
    {
        TeacherInfo *teacher = (TeacherInfo *)userInfo;
        [_commentLabel setText:teacher.title];
        [_commentLabel sizeToFit];
        [_commentLabel setOrigin:CGPointMake(_nameLabel.right + 15, (self.height - _commentLabel.height) / 2)];
    }
}

- (void)onChatClicked
{
    if([self.delegate respondsToSelector:@selector(contactItemChatClicked:)])
        [self.delegate contactItemChatClicked:self.userInfo];
}

@end
