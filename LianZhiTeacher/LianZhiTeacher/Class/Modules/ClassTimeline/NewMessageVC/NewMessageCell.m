//
//  NewMessageCell.m
//  LianZhiParent
//
//  Created by jslsxu on 15/8/22.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "NewMessageCell.h"

#define kNewMessageCellHeight                       50

@implementation NewMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        _avatarView = [[AvatarView alloc] initWithFrame:CGRectMake(15, (kNewMessageCellHeight - 35) / 2, 35, 35)];
        [self addSubview:_avatarView];
        
        _authorLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_authorLabel setFont:[UIFont systemFontOfSize:16]];
        [self addSubview:_authorLabel];
        
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_authorLabel setFont:[UIFont systemFontOfSize:16]];
        [self addSubview:_authorLabel];
        
        _sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, kNewMessageCellHeight - kLineHeight, self.width, kLineHeight)];
        [_sepLine setBackgroundColor:kSepLineColor];
        [self addSubview:_sepLine];
    }
    return self;
}

+ (NSNumber *)cellHeight:(TNModelItem *)modelItem cellWidth:(NSInteger)width
{
    return @(kNewMessageCellHeight);
}

- (void)onReloadData:(TNModelItem *)modelItem
{
    NewMessageItem *messageItem = (NewMessageItem *)modelItem;
    UserInfo *userInfo = messageItem.userInfo;
    [_avatarView setImageWithUrl:[NSURL URLWithString:userInfo.avatar]];
    [_authorLabel setText:userInfo.nickName];
}

@end
