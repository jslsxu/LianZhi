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
    UIView*         _bottomLine;
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
        
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, _avatarView.bottom + 10, self.width - 10 * 2, 0)];
        [_contentLabel setFont:[UIFont systemFontOfSize:14]];
        [_contentLabel setTextColor:[UIColor colorWithHexString:@"333333"]];
        [_contentLabel setNumberOfLines:0];
        [_contentLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [self addSubview:_contentLabel];
        
        _bottomLine = [[UIView alloc] initWithFrame:CGRectMake(10, self.height - kLineHeight, self.width - 10 * 2, kLineHeight)];
        [_bottomLine setBackgroundColor:kSepLineColor];
        [_bottomLine setHidden:YES];
        [_bottomLine setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];
        [self addSubview:_bottomLine];
    }
    return self;
}

- (void)setMessageDetailItem:(MessageDetailItem *)messageDetailItem{
    _messageDetailItem = messageDetailItem;
    [_avatarView sd_setImageWithURL:[NSURL URLWithString:_messageDetailItem.from_user.avatar]];
    [_nameLabel setText:_messageDetailItem.from_user.name];
    [_nameLabel sizeToFit];
    [_nameLabel setOrigin:CGPointMake(_avatarView.right + 5, _avatarView.centerY - 3 - _nameLabel.height)];
    
        [_statusLabel setText:_messageDetailItem.time_str];
        [_statusLabel sizeToFit];
        [_statusLabel setOrigin:CGPointMake(_avatarView.right + 5, _avatarView.centerY + 3)];
    
    [_contentLabel setText:_messageDetailItem.words];
    [_contentLabel sizeToFit];
    
    [self setHeight:_contentLabel.bottom + 10];
    BOOL onlyText = ![_messageDetailItem hasAudio] && ![_messageDetailItem hasPhoto] && ![_messageDetailItem hasVideo];
    [_bottomLine setHidden:!onlyText];
}


@end
