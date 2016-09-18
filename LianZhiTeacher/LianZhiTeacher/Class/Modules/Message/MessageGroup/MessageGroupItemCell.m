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
        [self setSize:CGSizeMake(kScreenWidth, 66)];
        [self setBackgroundColor:[UIColor whiteColor]];
        _logoView = [[LogoView alloc] initWithFrame:CGRectMake(10, 8, 50, 50)];
        [self.contentView addSubview:_logoView];
        
        _numIndicator = [[NumIndicator alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_numIndicator];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 10, 180, 18)];
        [_nameLabel setFont:[UIFont systemFontOfSize:14]];
        [_nameLabel setTextColor:[UIColor colorWithHexString:@"2c2c2c"]];
        [self.contentView addSubview:_nameLabel];
        
        //        _schoolLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        //        [_schoolLabel setFont:[UIFont systemFontOfSize:12]];
        //        [_schoolLabel setTextColor:[UIColor colorWithRed:86 / 255.0 green:86 / 255.0 blue:86 / 255.0 alpha:1.0]];
        //        [self.actualContentView addSubview:_schoolLabel];
        
        _massChatIndicator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MassChatIndicator"]];
        [_massChatIndicator setHidden:YES];
        [self.contentView addSubview:_massChatIndicator];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_nameLabel.right + 10, 10, self.width - 10 - (_nameLabel.right + 10), 18)];
        [_timeLabel setFont:[UIFont systemFontOfSize:11]];
        [_timeLabel setTextColor:[UIColor colorWithHexString:@"999999"]];
        [self.contentView addSubview:_timeLabel];
        
        _sepLine = [[UIView alloc] initWithFrame:CGRectMake(70, 0, self.width, 0.5)];
        [_sepLine setBackgroundColor:kSepLineColor];
        [self.contentView addSubview:_sepLine];
        
        _soundOff = [[UIImageView alloc] initWithImage:[UIImage imageNamed:(@"Nobell")]];
        [_soundOff setCenter:CGPointMake(self.width - _soundOff.width, 0)];
        [_soundOff setHidden:YES];
        [self.contentView addSubview:_soundOff];
        
//        _notificationIndicator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"NotificationIndicator"]];
//        [_notificationIndicator setHidden:YES];
//        [_notificationIndicator setOrigin:CGPointMake(70, 36 + (20 - _notificationIndicator.height) / 2)];
//        [self.contentView addSubview:_notificationIndicator];
        
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 36, _soundOff.left - 5 - 70, 20)];
        [_contentLabel setFont:[UIFont systemFontOfSize:13]];
        [_contentLabel setTextColor:[UIColor colorWithHexString:@"9a9a9a"]];
        [self.contentView addSubview:_contentLabel];
    }
    return self;
}

- (void)setMessageItem:(MessageGroupItem *)messageItem
{
    _messageItem = messageItem;
    //    if(_messageItem.soundOn)
    //        [self.moreOptionsButton setTitle:@"设为静音" forState:UIControlStateNormal];
    //    else
    //        [self.moreOptionsButton setTitle:@"取消静音" forState:UIControlStateNormal];
    //    [self.actualContentView setHeight:[self.class cellHeight:messageItem cellWidth:self.width].floatValue];
    if(_messageItem.fromInfo.logoImage)
        [_logoView setImage:_messageItem.fromInfo.logoImage];
    else
    {
        NSString *imageStr = nil;
        if(_messageItem.fromInfo.type == 13)
            imageStr = (@"NoAvatarDefault");
        else
            imageStr = (@"NoLogoDefault");
        [_logoView sd_setImageWithURL:[NSURL URLWithString:_messageItem.fromInfo.logoUrl]];
    }
    
    _timeLabel.text = _messageItem.formatTime;
    [_timeLabel sizeToFit];
    [_timeLabel setCenter:CGPointMake(self.width - 5 - _timeLabel.width / 2, _nameLabel.centerY)];
    
    ChatType fromType = _messageItem.fromInfo.type;
    NSString *name = _messageItem.fromInfo.name;
    if(fromType != ChatTypeClass && fromType != ChatTypeParents)
    {
        if(_messageItem.fromInfo.label.length > 0)
            name = [NSString stringWithFormat:@"%@(%@)",name,_messageItem.fromInfo.label];
    }
    _nameLabel.text = name;
    CGSize nameSize = [name boundingRectWithSize:CGSizeMake(_timeLabel.left - _nameLabel.left - 40, CGFLOAT_MAX) andFont:_nameLabel.font];
    [_nameLabel setWidth:MIN(_timeLabel.left - _nameLabel.left - 40, nameSize.width)];
    
    //群聊图标
    if(fromType == ChatTypeClass || fromType == ChatTypeGroup)
    {
        [_massChatIndicator setHidden:NO];
        [_massChatIndicator setOrigin:CGPointMake(_nameLabel.right + 10, _nameLabel.y + (_nameLabel.height - _massChatIndicator.height) / 2)];
        
        [_schoolLabel setHidden:NO];
        [_schoolLabel setText:_messageItem.fromInfo.label];
        [_schoolLabel sizeToFit];
        [_schoolLabel setFrame:CGRectMake(_massChatIndicator.right + 5, _nameLabel.y + (_nameLabel.height - _schoolLabel.height) / 2, MIN(_schoolLabel.width, _timeLabel.x - 5 - (_massChatIndicator.right + 5)), _schoolLabel.height)];
    }
    else
    {
        [_massChatIndicator setHidden:YES];
        [_schoolLabel setHidden:YES];
    }
    
    
    CGFloat spaceXStart = 70;
    CGFloat spaceXEnd = self.width - 5;
    //    _messageItem.fromInfo.type = ChatTypeAttendance;
    //通知图标
//    if([_messageItem.fromInfo isNotification])
//    {
//        [_notificationIndicator setHidden:NO];
//        spaceXStart = _notificationIndicator.right + 5;
//    }
//    else
//    {
//        [_notificationIndicator setHidden:YES];
//    }

    if(_messageItem.msgNum > 0)
    {
        [_numIndicator setHidden:NO];
        NSString *indicator = nil;
        if(_messageItem.msgNum > 99){
            indicator = @"99+";
        }
        else{
            indicator = kStringFromValue(_messageItem.msgNum);
        }
        [_numIndicator setIndicator:indicator];
        [_numIndicator setCenter:CGPointMake(spaceXEnd - _numIndicator.width / 2, 36 + (20 - _numIndicator.height) / 2)];
        spaceXEnd = _numIndicator.left - 5;
    }
    else
        _numIndicator.hidden = YES;
    
    if(_messageItem.soundOn){
        [_soundOff setHidden:YES];
    }
    else{
        [_soundOff setHidden:NO];
        [_soundOff setCenter:CGPointMake(spaceXEnd - _soundOff.width / 2, 36 + (20 - _soundOff.height) / 2)];
        spaceXEnd = _soundOff.left - 5;
    }
    [_contentLabel setFrame:CGRectMake(spaceXStart, 36, spaceXEnd - spaceXStart, 20)];
    NSString *content = _messageItem.content;
    if(_messageItem.im_at){
        NSMutableAttributedString *attrContent = [[NSMutableAttributedString alloc] initWithString:@"[有人@我]" attributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"F0003A"]}];
        [attrContent appendAttributedString:[[NSAttributedString alloc] initWithString:content attributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"9a9a9a"]}]];
        [_contentLabel setAttributedText:attrContent];
    }
    else{
        _contentLabel.text = content;
    }
    
    [_sepLine setY:66 - kLineHeight];
}
+ (NSNumber *)cellHeight:(MessageGroupItem *)messageItem cellWidth:(NSInteger)width;
{
    return @(66);
}

@end
