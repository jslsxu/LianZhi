//
//  MessageGroupItemCell.m
//  LianZhiParent
//
//  Created by jslsxu on 14/12/23.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "MessageGroupItemCell.h"
#import "MessageGroupListModel.h"

@implementation MessageGroupItemCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.width = kScreenWidth;
        [self setBackgroundColor:[UIColor whiteColor]];
        [self.moreOptionsButton setBackgroundColor:kCommonTeacherTintColor];
        _logoView = [[LogoView alloc] initWithFrame:CGRectMake(10, 8, 44, 44)];
        [_logoView setBorderWidth:2];
        [_logoView setBorderColor:[UIColor colorWithHexString:@"C0C0C0"]];
        [self.actualContentView addSubview:_logoView];
        
        _numIndicator = [[NumIndicator alloc] initWithFrame:CGRectZero];
        [self.actualContentView addSubview:_numIndicator];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, 180, 18)];
        [_nameLabel setFont:[UIFont systemFontOfSize:16]];
        [_nameLabel setTextColor:[UIColor colorWithRed:86 / 255.0 green:86 / 255.0 blue:86 / 255.0 alpha:1.0]];
        [self.actualContentView addSubview:_nameLabel];
        
        _massChatIndicator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MassChatIndicator"]];
        [_massChatIndicator setHidden:YES];
        [self.actualContentView addSubview:_massChatIndicator];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_nameLabel.right + 10, 10, self.width - 10 - (_nameLabel.right + 10), 18)];
        [_timeLabel setFont:[UIFont systemFontOfSize:13]];
        [_timeLabel setTextColor:[UIColor colorWithRed:81 / 255.0 green:81 / 255.0  blue:81 / 255.0  alpha:1.0]];
        [self.actualContentView addSubview:_timeLabel];
        
        _sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 0.5)];
        [_sepLine setBackgroundColor:[UIColor colorWithHexString:@"d8d8d8"]];
        [self.actualContentView addSubview:_sepLine];
        
        _soundOff = [[UIImageView alloc] initWithImage:[UIImage imageNamed:(@"Nobell.png")]];
        [_soundOff setCenter:CGPointMake(self.width - _soundOff.width, 0)];
        [_soundOff setHidden:YES];
        [self.actualContentView addSubview:_soundOff];
        
        _notificationIndicator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"NotificationIndicator"]];
        [_notificationIndicator setHidden:YES];
        [self.actualContentView addSubview:_notificationIndicator];
        
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 32, _soundOff.left - 5 - 60, 20)];
        [_contentLabel setFont:[UIFont systemFontOfSize:13]];
        [_contentLabel setTextColor:[UIColor colorWithRed:164 / 255.0 green:164 / 255.0  blue:164 / 255.0  alpha:1.0]];
        [self.actualContentView addSubview:_contentLabel];
    }
    return self;
}

- (void)setMessageItem:(MessageGroupItem *)messageItem
{
    _messageItem = messageItem;
    if(_messageItem.soundOn)
        [self.moreOptionsButton setTitle:@"设为静音" forState:UIControlStateNormal];
    else
        [self.moreOptionsButton setTitle:@"取消静音" forState:UIControlStateNormal];
    [self.actualContentView setHeight:[self.class cellHeight:messageItem cellWidth:self.width].floatValue];
    if(_messageItem.fromInfo.logoImage)
        [_logoView setImage:_messageItem.fromInfo.logoImage];
    else
    {
        NSString *imageStr = nil;
        if(_messageItem.fromInfo.type == 13)
            imageStr = (@"NoAvatarDefault.png");
        else
            imageStr = (@"NoLogoDefault.png");
        [_logoView setImageWithUrl:[NSURL URLWithString:_messageItem.fromInfo.logoUrl] placeHolder:[UIImage imageNamed:imageStr]];
    }
    
    _timeLabel.text = _messageItem.formatTime;
    [_timeLabel sizeToFit];
    [_timeLabel setRight:self.width - 10];
    
    NSString *name = _messageItem.fromInfo.name;
    if([_messageItem.fromInfo.label length] > 0)
        name = [NSString stringWithFormat:@"%@(%@)",name,_messageItem.fromInfo.label];
    _nameLabel.text = name;
    [_nameLabel setWidth:_timeLabel.left - 10 - _nameLabel.left];
    if(_messageItem.msgNum > 0)
    {
        [_numIndicator setHidden:NO];
        [_numIndicator setIndicator:kStringFromValue(_messageItem.msgNum)];
        [_numIndicator setCenter:CGPointMake(_logoView.right - _numIndicator.width / 2, _logoView.y + _numIndicator.height / 2)];
    }
    else
        _numIndicator.hidden = YES;
    NSString *content = _messageItem.content;
    if(content.length == 0 && _messageItem.audioItem)
        content = @"这是一条语音消息，点击播放收听";
    _contentLabel.text = content;
    [_sepLine setY:_contentLabel.bottom + 10 - 0.5];
    
    _soundOff.hidden = _messageItem.soundOn;
    _soundOff.y = _sepLine.y - 10 - _soundOff.height;
}
+ (NSNumber *)cellHeight:(MessageGroupItem *)messageItem cellWidth:(NSInteger)width;
{
//    CGSize contentSize = [messageItem.content boundingRectWithSize:CGSizeMake(width - 10 - 60, CGFLOAT_MAX) andFont:[UIFont systemFontOfSize:13]];
//    return contentSize.height + 32 + 10;
    return @(32 + 10 + 20);
}

@end
