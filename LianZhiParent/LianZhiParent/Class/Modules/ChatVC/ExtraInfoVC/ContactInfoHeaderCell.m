//
//  ContactInfoCell.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/8/14.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "ContactInfoHeaderCell.h"

@implementation ContactInfoHeaderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        _avatarView = [[AvatarView alloc] initWithRadius:25];
        [_avatarView setUserInteractionEnabled:YES];
        [self addSubview:_avatarView];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onAvatarTap)];
        [_avatarView addGestureRecognizer:tapGesture];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_nameLabel setTextColor:kCommonParentTintColor];
        [_nameLabel setFont:[UIFont systemFontOfSize:14]];
        [self addSubview:_nameLabel];
    }
    return self;
}

- (void)setUserInfo:(UserInfo *)userInfo{
    _userInfo = userInfo;
    [_avatarView setOrigin:CGPointMake(12, (75 - _avatarView.height) / 2)];
    [_avatarView sd_setImageWithURL:[NSURL URLWithString:_userInfo.avatar]];
    [_nameLabel setText:_userInfo.name];
    [_nameLabel setFrame:CGRectMake(_avatarView.right + 10, 0, self.width - 10 - (_avatarView.right + 10), 75)];
}

+ (NSNumber *)cellHeight:(TNModelItem *)modelItem cellWidth:(NSInteger)width{
    return @(75);
}

- (void)onAvatarTap{
    [[PBImageController sharedInstance] showForView:_avatarView placeHolder:_avatarView.image url:self.userInfo.avatar];
}

@end
