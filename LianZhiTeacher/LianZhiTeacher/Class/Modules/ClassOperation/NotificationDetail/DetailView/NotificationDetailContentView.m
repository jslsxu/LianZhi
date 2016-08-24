//
//  NotificationDetailContentView.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/7/30.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "NotificationDetailContentView.h"

@interface  NotificationDetailContentView(){
    AvatarView*     _avatarView;
    UILabel*        _nameLabel;
    UILabel*        _statusLabel;
    UILabel*        _contentLabel;
    UIView*         _sepLine;
}

@end

@implementation NotificationDetailContentView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self setClipsToBounds:YES];
        _avatarView = [[AvatarView alloc] initWithRadius:20];
        [_avatarView setOrigin:CGPointMake(10, 10)];
        [self addSubview:_avatarView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_nameLabel setTextColor:[UIColor colorWithHexString:@"333333"]];
        [_nameLabel setFont:[UIFont systemFontOfSize:14]];
        [self addSubview:_nameLabel];
        
        _statusLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_statusLabel setTextColor:[UIColor colorWithHexString:@"9a9a9a"]];
        [_statusLabel setFont:[UIFont systemFontOfSize:12]];
        [self addSubview:_statusLabel];
        
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, _avatarView.bottom + 5, self.width - 10 * 2, 0)];
        [_contentLabel setFont:[UIFont systemFontOfSize:14]];
        [_contentLabel setTextColor:[UIColor colorWithHexString:@"333333"]];
        [_contentLabel setNumberOfLines:0];
        [_contentLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [self addSubview:_contentLabel];
        
        _sepLine = [[UIView alloc] initWithFrame:CGRectMake(10, kLineHeight, self.width - 10 * 2, kLineHeight)];
        [_sepLine setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];
        [_sepLine setBackgroundColor:kSepLineColor];
        [self addSubview:_sepLine];
    }
    return self;
}

- (void)setNotificationItem:(NotificationItem *)notificationItem{
    _notificationItem = notificationItem;
    [_avatarView setImageWithUrl:[NSURL URLWithString:_notificationItem.user.avatar]];
    [_nameLabel setText:_notificationItem.user.name];
    [_nameLabel sizeToFit];
    [_nameLabel setOrigin:CGPointMake(_avatarView.right + 5, _avatarView.centerY - 2 - _nameLabel.height)];
    
    [_statusLabel setText:_notificationItem.created_time];
    [_statusLabel sizeToFit];
    [_statusLabel setOrigin:CGPointMake(_avatarView.right + 5, _avatarView.centerY + 2)];
    
    [_contentLabel setText:_notificationItem.words];
    [_contentLabel sizeToFit];
    
    [self setHeight:_contentLabel.bottom + 10];
}

- (void)setSendEntity:(NotificationSendEntity *)sendEntity{
    _sendEntity = sendEntity;
    [_avatarView setImageWithUrl:[NSURL URLWithString:_sendEntity.authorUser.avatar]];
    [_nameLabel setText:_sendEntity.authorUser.name];
    [_nameLabel sizeToFit];
    [_nameLabel setOrigin:CGPointMake(_avatarView.right + 5, _avatarView.centerY - 2 - _nameLabel.height)];
    
//    [_statusLabel setText:_sendEntity.created_time];
//    [_statusLabel sizeToFit];
//    [_statusLabel setOrigin:CGPointMake(_avatarView.right + 5, _avatarView.centerY + 2)];
    
    [_contentLabel setText:_sendEntity.words];
    [_contentLabel sizeToFit];
    
    [self setHeight:_contentLabel.bottom + 10];
}

@end
