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
        _avatarView = [[AvatarView alloc] initWithFrame:CGRectMake(15, (kNewMessageCellHeight - 36) / 2, 36, 36)];
        [self addSubview:_avatarView];
        
        _authorLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 8, 180, 12)];
        [_authorLabel setFont:[UIFont systemFontOfSize:14]];
        [_authorLabel setTextColor:[UIColor darkGrayColor]];
        [self addSubview:_authorLabel];
        
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 24, 180, 10)];
        [_authorLabel setFont:[UIFont systemFontOfSize:13]];
        [_authorLabel setTextColor:[UIColor lightGrayColor]];
        [self addSubview:_authorLabel];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 38, 180, 10)];
        [_timeLabel setTextColor:[UIColor lightGrayColor]];
        [_timeLabel setFont:[UIFont systemFontOfSize:12]];
        [self addSubview:_timeLabel];
        
        _contentImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.width - 36 - 15, (kNewMessageCellHeight - 36) / 2, 36, 36)];
        [_contentImageView setBackgroundColor:[UIColor colorWithHexString:@"cccccc"]];
        [self addSubview:_contentImageView];
        
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
    [_authorLabel setText:userInfo.name];
    [_contentLabel setText:messageItem.comment_content];
    [_timeLabel setText:messageItem.ctime];
    if(messageItem.feedItem.feedType == FeedTypePhoto)
        [_contentImageView sd_setImageWithURL:[NSURL URLWithString:messageItem.feedItem.feedPhoto] placeholderImage:nil];
    else
        [_contentImageView setImage:nil];
}

@end
