//
//  MessageDetailItemCell.m
//  LianZhiParent
//
//  Created by jslsxu on 14/12/24.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "MessageDetailItemCell.h"
 NSString *const  kMessageDeleteNotitication = @"MessageDeleteNotitication";
NSString *const  kMessageDeleteModelItemKey = @"MessageDeleteModelItemKey";
#define kContentFont            [UIFont systemFontOfSize:15]

#define kOperationHeight        32

@implementation MessageDetailItemCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self setBackgroundColor:[UIColor clearColor]];
        
        _bgImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"WhiteBG.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)]];
        [_bgImageView setUserInteractionEnabled:YES];
        [self addSubview:_bgImageView];
        
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_contentLabel setBackgroundColor:[UIColor clearColor]];
        [_contentLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [_contentLabel setNumberOfLines:0];
        [_contentLabel setFont:kContentFont];
        [_contentLabel setTextColor:[UIColor colorWithHexString:@"4d4d4d"]];
        [_bgImageView addSubview:_contentLabel];
        
        _voiceButton = [[MessageVoiceButton alloc] initWithFrame:CGRectMake(0, 0, self.width - 50, 45)];
        [_voiceButton addTarget:self action:@selector(onVoiceButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_bgImageView addSubview:_voiceButton];
        
        _sepLine = [[UIView alloc] initWithFrame:CGRectZero];
        [_sepLine setBackgroundColor:[UIColor colorWithHexString:@"D8D8D8"]];
        [_bgImageView addSubview:_sepLine];
        
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteButton addTarget:self action:@selector(onMessageDeleteButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_deleteButton setImage:[UIImage imageNamed:@"MessageDetailTrash.png"] forState:UIControlStateNormal];
        [_bgImageView addSubview:_deleteButton];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_timeLabel setBackgroundColor:[UIColor clearColor]];
        [_timeLabel setFont:[UIFont systemFontOfSize:14]];
        [_timeLabel setTextColor:[UIColor colorWithRed:133 / 255.0 green:133 / 255.0 blue:133 / 255.0 alpha:1.f]];
        [_bgImageView addSubview:_timeLabel];
    }
    return self;
}

- (void)onReloadData:(TNModelItem *)modelItem
{
    MessageDetailItem *item = (MessageDetailItem *)modelItem;
    CGFloat height = 0;
    if(item.audioItem)
    {
        height = 150;
        [_contentLabel setText:@"这是一条语音内容，点击播放:"];
        [_contentLabel sizeToFit];
        [_contentLabel setOrigin:CGPointMake(12, 12)];
        
        [_voiceButton setHidden:NO];
        [_voiceButton setAudioItem:item.audioItem];
        [_voiceButton setOrigin:CGPointMake(12, 12 + _contentLabel.bottom)];
    }
    else
    {
        [_voiceButton setHidden:YES];
        CGSize size = [item.content boundingRectWithSize:CGSizeMake(self.width - 12 * 4, 0) andFont:kContentFont];
        height = 14 + 12 * 2 + kOperationHeight + size.height;
        [_contentLabel setText:item.content];
        [_contentLabel setFrame:CGRectMake(12, 12, self.width - 12 * 4, size.height)];
    }
    
    [_bgImageView setFrame:CGRectMake(12, 7, self.width - 12 * 2, height - 7 * 2)];
    [_sepLine setFrame:CGRectMake(0, _bgImageView.height - kOperationHeight, _bgImageView.width, 0.5)];
    [_deleteButton setFrame:CGRectMake(0, _sepLine.bottom, 50, kOperationHeight)];
    [_timeLabel setText:item.timeStr];
    [_timeLabel sizeToFit];
    [_timeLabel setFrame:CGRectMake(_bgImageView.width - 12 - _timeLabel.width, _sepLine.bottom + (kOperationHeight - _timeLabel.height) / 2, _timeLabel.width, _timeLabel.height)];
    
}

- (void)onVoiceButtonClicked
{
    MessageDetailItem *item = (MessageDetailItem *)self.modelItem;
    [_voiceButton setVoiceWithURL:[NSURL URLWithString:item.audioItem.audioUrl] withAutoPlay:YES];
}

- (void)onMessageDeleteButtonClicked
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kMessageDeleteNotitication object:nil userInfo:@{kMessageDeleteModelItemKey : self.modelItem}];
}

+ (NSNumber *)cellHeight:(TNModelItem *)modelItem cellWidth:(NSInteger)width
{
    MessageDetailItem *item = (MessageDetailItem *)modelItem;
    if(item.audioItem)
    {
        return @(150);
    }
    else
    {
        CGSize size = [item.content boundingRectWithSize:CGSizeMake(width - 12 * 4, 0) andFont:kContentFont];
        
        return @(14 + 12 * 2 + kOperationHeight + size.height);
    }
}
@end
