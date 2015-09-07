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
#define kContentFont            [UIFont systemFontOfSize:14]

#define kBGTopMargin            20
#define kBGBottomMargin         20
#define kOperationHeight        32
#define kBGViewHMargin          10
#define kContentHMargin         10

@implementation MessageDetailItemCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.width = kScreenWidth;
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self setBackgroundColor:[UIColor clearColor]];
        
        _bgView = [[UIImageView alloc] initWithFrame:CGRectMake(kBGViewHMargin, kBGTopMargin, self.width - kBGViewHMargin * 2, 0)];
        [_bgView setBackgroundColor:[UIColor whiteColor]];
        [_bgView.layer setCornerRadius:15];
        [_bgView.layer setMasksToBounds:YES];
        [self addSubview:_bgView];
        
        _logoView = [[LogoView alloc] initWithFrame:CGRectMake(20, 5, 45, 45)];
        [_logoView setBorderColor:[UIColor whiteColor]];
        [_logoView setBorderWidth:2];
        [self addSubview:_logoView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_logoView.right + 10, 0, 100, kOperationHeight)];
        [_nameLabel setFont:[UIFont systemFontOfSize:13]];
        [_nameLabel setTextColor:[UIColor colorWithHexString:@"9a9a9a"]];
        [_bgView addSubview:_nameLabel];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_timeLabel setBackgroundColor:[UIColor clearColor]];
        [_timeLabel setFont:[UIFont systemFontOfSize:14]];
        [_timeLabel setTextColor:[UIColor colorWithHexString:@"9a9a9a"]];
        [_bgView addSubview:_timeLabel];
        
        _sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, kOperationHeight, _bgView.width, kLineHeight)];
        [_sepLine setBackgroundColor:kSepLineColor];
        [_bgView addSubview:_sepLine];
        
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(kContentHMargin, kOperationHeight + 10, _bgView.width - kContentHMargin * 2, 0)];
        [_contentLabel setBackgroundColor:[UIColor clearColor]];
        [_contentLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [_contentLabel setNumberOfLines:0];
        [_contentLabel setFont:kContentFont];
        [_contentLabel setTextColor:[UIColor colorWithHexString:@"2c2c2c"]];
        [_bgView addSubview:_contentLabel];
        
        _voiceButton = [[MessageVoiceButton alloc] initWithFrame:CGRectMake(0, 0, self.width - 50, 45)];
        [_voiceButton addTarget:self action:@selector(onVoiceButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:_voiceButton];
    }
    return self;
}

- (void)onReloadData:(TNModelItem *)modelItem
{
    MessageDetailItem *item = (MessageDetailItem *)modelItem;
    [_nameLabel setText:item.author];
    CGFloat height = kOperationHeight + kBGTopMargin;
    if(item.audioItem)
    {
        height += 100;
        [_contentLabel setText:@"这是一条语音内容，点击播放:"];
        [_contentLabel setFrame:CGRectMake(kContentHMargin, kOperationHeight + kContentHMargin, _bgView.width - kContentHMargin * 2, 20)];
        
        [_voiceButton setHidden:NO];
        [_voiceButton setAudioItem:item.audioItem];
        [_voiceButton setOrigin:CGPointMake(kContentHMargin, kContentHMargin + _contentLabel.bottom)];
    }
    else
    {
        [_voiceButton setHidden:YES];
        CGSize size = [item.content boundingRectWithSize:CGSizeMake(self.width - kBGViewHMargin * 4, 0) andFont:kContentFont];
        [_contentLabel setText:item.content];
        [_contentLabel setFrame:CGRectMake(kContentHMargin, kOperationHeight + kContentHMargin, size.width, size.height)];
        height += size.height + kContentHMargin * 2;
    }
    height += kBGBottomMargin;
    [_bgView setHeight:height - kBGBottomMargin - kBGTopMargin];
    [_timeLabel setText:item.timeStr];
    [_timeLabel sizeToFit];
    [_timeLabel setFrame:CGRectMake(_bgView.width - kContentHMargin - _timeLabel.width, (kOperationHeight - _timeLabel.height) / 2, _timeLabel.width, _timeLabel.height)];
    
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
        return @(kBGTopMargin + kBGBottomMargin + kOperationHeight + 100);
    }
    else
    {
        CGSize size = [item.content boundingRectWithSize:CGSizeMake(width - kContentHMargin * 4, 0) andFont:kContentFont];
        
        return @(kBGTopMargin + kBGBottomMargin + kOperationHeight + kContentHMargin + size.height);
    }
}
@end
