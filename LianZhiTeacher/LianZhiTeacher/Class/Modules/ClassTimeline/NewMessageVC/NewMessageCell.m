//
//  NewMessageCell.m
//  LianZhiParent
//
//  Created by jslsxu on 15/8/22.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "NewMessageCell.h"

#define kNewMessageCellHeight                       60

@implementation NewMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        _avatarView = [[AvatarView alloc] initWithFrame:CGRectMake(15, (kNewMessageCellHeight - 36) / 2, 36, 36)];
        [self addSubview:_avatarView];
        
        _contentImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.width - 36 - 15, (kNewMessageCellHeight - 36) / 2, 36, 36)];
        [_contentImageView setBackgroundColor:[UIColor colorWithHexString:@"cccccc"]];
        [self addSubview:_contentImageView];
        
        _authorLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 8, 180, 12)];
        [_authorLabel setFont:[UIFont systemFontOfSize:14]];
        [_authorLabel setTextColor:[UIColor colorWithHexString:@"2c2c2c"]];
        [self addSubview:_authorLabel];
        
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 26, _contentImageView.x - 60 - 10, 10)];
        [_contentLabel setFont:[UIFont systemFontOfSize:13]];
        [_contentLabel setTextColor:[UIColor colorWithHexString:@"999999"]];
        [self addSubview:_contentLabel];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 42, 180, 10)];
        [_timeLabel setTextColor:[UIColor lightGrayColor]];
        [_timeLabel setFont:[UIFont systemFontOfSize:10]];
        [self addSubview:_timeLabel];
        
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
    [_avatarView sd_setImageWithURL:[NSURL URLWithString:userInfo.avatar]];
    [_authorLabel setText:userInfo.label];
    [_contentLabel setText:messageItem.comment_content];
    [_timeLabel setText:messageItem.ctime];
    if(messageItem.feedItem.feedType == FeedTypePhoto)
        [_contentImageView sd_setImageWithURL:[NSURL URLWithString:messageItem.feedItem.feedPhoto] placeholderImage:nil];
    else if(messageItem.feedItem.feedType == FeedTypeAudio)
    {
        [_contentImageView setImage:[UIImage imageNamed:@"NewMessageAudio"]];
    }
    else
    {
        UILabel *label = [[UILabel alloc] initWithFrame:_contentImageView.frame];
        [label setClipsToBounds:YES];
        [label setFont:[UIFont systemFontOfSize:10]];
        [label setLineBreakMode:NSLineBreakByWordWrapping];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setNumberOfLines:0];
        [label setText:messageItem.feedItem.feedText];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIGraphicsBeginImageContextWithOptions(label.size,NO,0);
            [label.layer renderInContext:UIGraphicsGetCurrentContext()];
            UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            dispatch_async(dispatch_get_main_queue(), ^{
                [_contentImageView setImage:image];
            });
        });
    }
}

@end
