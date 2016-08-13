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
        [self addSubview:_avatarView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_nameLabel setTextColor:[UIColor colorWithHexString:@"28c4d8"]];
        [_nameLabel setFont:[UIFont systemFontOfSize:14]];
        [self addSubview:_nameLabel];
    }
    return self;
}

- (void)setUserInfo:(UserInfo *)userInfo{
    _userInfo = userInfo;
    [_avatarView setOrigin:CGPointMake(12, (75 - _avatarView.height) / 2)];
    [_avatarView setImageWithUrl:[NSURL URLWithString:_userInfo.avatar]];
    [_nameLabel setText:_userInfo.name];
    [_nameLabel setFrame:CGRectMake(_avatarView.right + 10, 0, self.width - 10 - (_avatarView.right + 10), 75)];
}

+ (NSNumber *)cellHeight:(TNModelItem *)modelItem cellWidth:(NSInteger)width{
    return @(75);
}

@end
