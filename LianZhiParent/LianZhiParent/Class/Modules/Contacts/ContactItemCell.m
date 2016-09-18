//
//  ContactItemCell.m
//  LianZhiParent
//
//  Created by jslsxu on 14/12/18.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "ContactItemCell.h"
#import "JSMessagesViewController.h"

@implementation ContactItemCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self setSize:CGSizeMake(kScreenWidth, 60)];
        [self setBackgroundColor:[UIColor whiteColor]];
        _logoView = [[AvatarView alloc] initWithFrame:CGRectMake(12, (self.height - 32) / 2, 32, 32)];;
        [self addSubview:_logoView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_nameLabel setBackgroundColor:[UIColor clearColor]];
        [_nameLabel setTextColor:[UIColor colorWithHexString:@"2c2c2c"]];
        [_nameLabel setFont:[UIFont systemFontOfSize:14]];
        [self addSubview:_nameLabel];
        
        _commentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_commentLabel setFont:[UIFont systemFontOfSize:12]];
        [_commentLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:_commentLabel];
        
        _sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - kLineHeight, self.width, kLineHeight)];
        [_sepLine setBackgroundColor:kSepLineColor];
        [self addSubview:_sepLine];
    }
    return self;
}

- (void)setUserInfo:(UserInfo *)userInfo{
    _userInfo = userInfo;
    if([_userInfo isKindOfClass:[TeacherInfo class]]){
        TeacherInfo *teacherInfo = (TeacherInfo *)_userInfo;
        [_logoView sd_setImageWithURL:[NSURL URLWithString:teacherInfo.avatar]];
        [_logoView setStatus:teacherInfo.actived ? nil : @"未下载"];
        [_nameLabel setText:teacherInfo.name];
        [_nameLabel sizeToFit];
        [_nameLabel setFrame:CGRectMake(_logoView.right + 10, (self.height - _nameLabel.height) / 2, _nameLabel.width, _nameLabel.height)];
        
        [_commentLabel setBackgroundColor:[UIColor colorWithHexString:@"02c994"]];
        [_commentLabel setTextColor:[UIColor whiteColor]];
        NSString *title = teacherInfo.title;
        if(title.length == 0){
            title = @"教师";
        }
        [_commentLabel setText:title];
        [_commentLabel sizeToFit];
        [_commentLabel setSize:CGSizeMake(_commentLabel.width + 6, (NSInteger)_commentLabel.height + 2)];
        [_commentLabel setOrigin:CGPointMake(_nameLabel.right + 10, (self.height - _commentLabel.height) / 2)];
        [_commentLabel.layer setCornerRadius:_commentLabel.height / 2];
        [_commentLabel.layer setMasksToBounds:YES];
    }
    else if([_userInfo isKindOfClass:[ChildInfo class]]){
        ChildInfo* childInfo = (ChildInfo *)_userInfo;
        [_logoView sd_setImageWithURL:[NSURL URLWithString:childInfo.avatar]];
        [_logoView setStatus:childInfo.actived ? nil : @"未下载"];
        [_nameLabel setText:childInfo.name];
        [_nameLabel sizeToFit];
        [_nameLabel setFrame:CGRectMake(_logoView.right + 10, (self.height - _nameLabel.height) / 2, _nameLabel.width, _nameLabel.height)];
        
        [_commentLabel setTextColor:[UIColor colorWithHexString:@"999999"]];
        [_commentLabel setBackgroundColor:[UIColor clearColor]];
        [_commentLabel setText:[NSString stringWithFormat:@"%zd位家长",childInfo.family.count]];
        [_commentLabel sizeToFit];
        [_commentLabel setOrigin:CGPointMake(_nameLabel.right + 10, (self.height - _commentLabel.height) / 2)];
    }
}

@end
