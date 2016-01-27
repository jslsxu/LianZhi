//
//  MessageCell.m
//  LianZhiParent
//
//  Created by jslsxu on 15/9/20.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "MessageCell.h"
#import "UUImageAvatarBrowser.h"
#import "MFWFace.h"
@implementation MessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self setBackgroundColor:[UIColor clearColor]];
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [_indicatorView setHidesWhenStopped:YES];
        [self addSubview:_indicatorView];
        
        _sendFailImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SendFail"]];
        [_sendFailImageView setUserInteractionEnabled:YES];
        [_sendFailImageView setHidden:YES];
        [self addSubview:_sendFailImageView];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onResendMessage)];
        [_sendFailImageView addGestureRecognizer:tapGesture];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.width - 120) / 2, 5, 120, 15)];
        [_timeLabel setTextAlignment:NSTextAlignmentCenter];
        [_timeLabel setFont:[UIFont systemFontOfSize:12]];
        [_timeLabel setTextColor:[UIColor whiteColor]];
        [_timeLabel setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.2]];
        [_timeLabel.layer setCornerRadius:2];
        [_timeLabel.layer setMasksToBounds:YES];
        [self addSubview:_timeLabel];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(kAvatarHMargin, 10 + kTimeLabelHeight, kScreenWidth - kAvatarHMargin * 2, 10)];
        [_nameLabel setTextColor:[UIColor colorWithHexString:@"8f8f8f"]];
        [_nameLabel setFont:[UIFont systemFontOfSize:10]];
        [self addSubview:_nameLabel];
        
        _avatarView = [[AvatarView alloc] initWithFrame:CGRectMake(0, _nameLabel.bottom + 5, 34, 34)];
        [self addSubview:_avatarView];
        
        _contentButton = [UUMessageContentButton buttonWithType:UIButtonTypeCustom];
        [_contentButton addTarget:self action:@selector(onContentButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_contentButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _contentButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _contentButton.titleLabel.numberOfLines = 0;
        [self addSubview:_contentButton];
        
        _giftView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_giftView setClipsToBounds:YES];
        [_giftView setContentMode:UIViewContentModeScaleAspectFill];
        [_contentButton addSubview:_giftView];
        
        _giftDetailLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_giftDetailLabel setTextColor:[UIColor whiteColor]];
        [_giftDetailLabel setNumberOfLines:0];
        [_giftDetailLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [_contentButton addSubview:_giftDetailLabel];
        
        UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onLongPress)];
        [longPressGesture setMinimumPressDuration:1];
        [_contentButton addGestureRecognizer:longPressGesture];
        
        _audioTimeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_audioTimeLabel setFont:[UIFont systemFontOfSize:14]];
        [_audioTimeLabel setTextColor:[UIColor colorWithHexString:@"999999"]];
        [self addSubview:_audioTimeLabel];
        
        _playButton = [[ChatVoiceButton alloc] init];
        [_playButton addTarget:self action:@selector(onAudioCLicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_playButton];
        
        _revokeMessageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_revokeMessageLabel setTextAlignment:NSTextAlignmentCenter];
        [_revokeMessageLabel setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.2]];
        [_revokeMessageLabel setTextColor:[UIColor whiteColor]];
        [_revokeMessageLabel setFont:[UIFont systemFontOfSize:13]];
        [_revokeMessageLabel.layer setCornerRadius:4];
        [_revokeMessageLabel.layer setMasksToBounds:YES];
        [_revokeMessageLabel setHidden:YES];
        [self addSubview:_revokeMessageLabel];
        
    }
    return self;
}

- (void)onReloadData:(TNModelItem *)modelItem
{
    MessageItem *messageItem = (MessageItem *)modelItem;
    [_timeLabel setHidden:messageItem.messageContent.hideTime];
    [_timeLabel setText:messageItem.messageContent.ctime];
    if(MessageStatusSending == messageItem.messageStatus)
        [_indicatorView startAnimating];
    else
        [_indicatorView stopAnimating];
    [_sendFailImageView setHidden:MessageStatusFailed != messageItem.messageStatus];
    NSInteger spaceYStart = kTimeLabelHeight + 10;
    if(messageItem.messageContent.hideTime)
        spaceYStart = 0;

    if(messageItem.from == UUMessageFromMe)
    {
        [_nameLabel setTextAlignment:NSTextAlignmentRight];
        [_avatarView setX:self.width - kAvatarHMargin - _avatarView.width];
        [_contentButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_contentButton setBackgroundImage:[[UIImage imageNamed:@"MessageSendedBG"] resizableImageWithCapInsets:UIEdgeInsetsMake(26, 20, 8, 20)] forState:UIControlStateNormal];
        [_contentButton setBackgroundImage:[[UIImage imageNamed:@"MessageSendedBGHighlighted"] resizableImageWithCapInsets:UIEdgeInsetsMake(26, 20, 8, 20)] forState:UIControlStateHighlighted];
        [_contentButton setContentEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 15)];
        [_playButton setBackgroundImage:[[UIImage imageNamed:@"MessageSendedBG"] resizableImageWithCapInsets:UIEdgeInsetsMake(26, 20, 8, 20)] forState:UIControlStateNormal];
        [_playButton setBackgroundImage:[[UIImage imageNamed:@"MessageSendedBGHighlighted"] resizableImageWithCapInsets:UIEdgeInsetsMake(26, 20, 8, 20)] forState:UIControlStateHighlighted];
        [_contentButton setContentEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 15)];
        [_nameLabel setText:@"我自己"];
    }
    else
    {
        [_nameLabel setTextAlignment:NSTextAlignmentLeft];
        [_avatarView setX:kAvatarHMargin];
        [_contentButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_contentButton setBackgroundImage:[[UIImage imageNamed:@"MessageReceivedBG"] resizableImageWithCapInsets:UIEdgeInsetsMake(26, 20, 8, 20)] forState:UIControlStateNormal];
        [_contentButton setBackgroundImage:[[UIImage imageNamed:@"MessageReceivedBGHighlighted"] resizableImageWithCapInsets:UIEdgeInsetsMake(26, 20, 8, 20)] forState:UIControlStateHighlighted];
        [_contentButton setContentEdgeInsets:UIEdgeInsetsMake(10, 15, 10, 10)];
        [_playButton setBackgroundImage:[[UIImage imageNamed:@"MessageReceivedBG"] resizableImageWithCapInsets:UIEdgeInsetsMake(26, 20, 8, 20)] forState:UIControlStateNormal];
        [_playButton setBackgroundImage:[[UIImage imageNamed:@"MessageReceivedBGHighlighted"] resizableImageWithCapInsets:UIEdgeInsetsMake(26, 20, 8, 20)] forState:UIControlStateHighlighted];
        UserInfo *userInfo = messageItem.userInfo;
        [_nameLabel setText:userInfo.name];
    }
    [_nameLabel setY:spaceYStart];
    spaceYStart += _nameLabel.height + 5;
    [_avatarView setImageWithUrl:[NSURL URLWithString:messageItem.userInfo.avatar]];
    [_avatarView setY:spaceYStart];
    
    [_contentButton setY:spaceYStart];
    [_contentButton setImage:nil forState:UIControlStateNormal];
    [_contentButton setTitle:nil forState:UIControlStateNormal];
    [_contentButton.backImageView setImage:nil];
    [_contentButton.backImageView setHidden:YES];
    [_contentButton setHidden:NO];
    [_playButton setHidden:YES];
    [_audioTimeLabel setHidden:YES];
    [_revokeMessageLabel setHidden:YES];
    [_giftDetailLabel setHidden:YES];
    [_giftView setHidden:YES];
    MessageType type = messageItem.messageContent.messageType;
    if(type == UUMessageTypeText)
    {
        CGSize contentSize = [messageItem.messageContent.text boundingRectWithSize:CGSizeMake(kScreenWidth - 50 * 2 - 10 - 15, CGFLOAT_MAX) andFont:[UIFont systemFontOfSize:14]];
        [_contentButton setTitle:messageItem.messageContent.text forState:UIControlStateNormal];
        [_contentButton setSize:CGSizeMake(contentSize.width + 10 + 15, contentSize.height + 10 * 2)];
    }
    else if(type == UUMessageTypePicture)
    {
        PhotoItem *photoItem = messageItem.messageContent.photoItem;
        [_contentButton.backImageView setHidden:NO];
        if(photoItem.width > photoItem.height)
            [_contentButton setSize:CGSizeMake(120, 120 * photoItem.height / photoItem.width)];
        else
            [_contentButton setSize:CGSizeMake(120 * photoItem.width / photoItem.height, 120)];
        if(photoItem.image)
            [_contentButton.backImageView setImage:photoItem.image];
        else
            [_contentButton.backImageView sd_setImageWithURL:[NSURL URLWithString:photoItem.thumbnailUrl]];
        [self makeMaskView:_contentButton.backImageView withImage:[_contentButton backgroundImageForState:UIControlStateNormal]];
    }
    else if(type == UUMessageTypeVoice)
    {
        AudioItem *audioItem = messageItem.messageContent.audioItem;
        NSInteger second = audioItem.timeSpan;
        NSInteger maxWidth = kScreenWidth - 50 * 2 - 60 - 40;
        NSInteger width = maxWidth * second / 120 + 40;
        [_contentButton setSize:CGSizeMake(width, 32)];
        [_contentButton setHidden:YES];
        [_playButton setHidden:NO];
        [_audioTimeLabel setHidden:NO];
        [_playButton setSize:_contentButton.size];
        [_audioTimeLabel setText:[Utility formatStringForTime:messageItem.messageContent.audioItem.timeSpan]];
        [_audioTimeLabel sizeToFit];
        if(messageItem.from == UUMessageFromMe)
        {
            
            _playButton.type = MLPlayVoiceButtonTypeRight;
            [_playButton setOrigin:CGPointMake(kScreenWidth - 50 - _contentButton.width, _avatarView.y)];
            [_audioTimeLabel setOrigin:CGPointMake(_playButton.x - _audioTimeLabel.width - 10, _playButton.y + (_playButton.height - _audioTimeLabel.height) / 2)];
        }
        else
        {
            _playButton.type = MLPlayVoiceButtonTypeLeft;
            [_playButton setOrigin:CGPointMake(50, _avatarView.y)];
            [_audioTimeLabel setOrigin:CGPointMake(_playButton.right + 10, _playButton.y + (_playButton.height - _audioTimeLabel.height) / 2)];
        }
    }
    else  if(type == UUMessageTypeFace)//表情
    {
        NSString *faceText = messageItem.messageContent.text;
        NSInteger index = [MFWFace indexForFace:faceText];
        [_contentButton setBackgroundImage:nil forState:UIControlStateNormal];
        [_contentButton setBackgroundImage:nil forState:UIControlStateHighlighted];
        [_contentButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"biaoqing%ld",(long)(index + 1)]] forState:UIControlStateNormal];
        [_contentButton setSize:CGSizeMake(kFaceWith, kFaceWith)];
    }
    else if(type == UUMessageTypeRevoked)      //已撤销
    {
        _contentButton.hidden = YES;
        _revokeMessageLabel.hidden = NO;
        [_revokeMessageLabel setText:@"你撤回了一条消息"];
        [_revokeMessageLabel sizeToFit];
        [_revokeMessageLabel setFrame:CGRectMake((self.width - _revokeMessageLabel.width - 10) / 2, _nameLabel.bottom, _revokeMessageLabel.width + 10, _revokeMessageLabel.height + 4)];
    }
    else if(type == UUMessageTypeGift)
    {
        NSInteger leftMargin = 10;
        NSInteger rightMargin =  10;
        [_giftView setHidden:NO];
        [_giftDetailLabel setHidden:NO];
        [_contentButton setSize:CGSizeMake(180, 60)];
        [_contentButton.backImageView setHidden:NO];
        [_contentButton.backImageView setBackgroundColor:[UIColor colorWithHexString:@"fa9d3b"]];
        
        [_giftView setFrame:CGRectMake(leftMargin, 5, 50, 50)];
        [_giftView sd_setImageWithURL:[NSURL URLWithString:@"http://pic14.nipic.com/20110522/7411759_164157418126_2.jpg"] placeholderImage:nil];
        
        [_giftDetailLabel setFrame:CGRectMake(_giftView.right + 10, 10, _contentButton.width - rightMargin - (_giftView.right + 10), 40)];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        [paragraphStyle setLineSpacing:6];
        NSMutableAttributedString *giftDetailStr = [[NSMutableAttributedString alloc] initWithString:@"请收下我的心意\n" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13],NSParagraphStyleAttributeName : paragraphStyle}];
        [giftDetailStr appendAttributedString:[[NSAttributedString alloc] initWithString:@"点击查看" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:11],NSParagraphStyleAttributeName : paragraphStyle}]];
        [_giftDetailLabel setAttributedText:giftDetailStr];

    }
    else
    {
        _contentButton.hidden = YES;
    }
    
    if(UUMessageFromMe == messageItem.from)
    {
        [_contentButton setOrigin:CGPointMake(kScreenWidth - 50 - _contentButton.width, spaceYStart)];
        [_indicatorView setCenter:CGPointMake(_contentButton.x - 30, _contentButton.centerY)];
    }
    else
    {
        [_contentButton setOrigin:CGPointMake(50, spaceYStart)];
        [_indicatorView setCenter:CGPointMake(_contentButton.right + 30, _contentButton.centerY)];
    }
    [_sendFailImageView setCenter:_indicatorView.center];
}

- (void)onAudioCLicked
{
    MessageItem *messageItem = (MessageItem *)self.modelItem;
    AudioItem *audioItem = messageItem.messageContent.audioItem;
    [_playButton setVoiceWithURL:[NSURL URLWithString:audioItem.audioUrl] withAutoPlay:YES];
}

- (void)onLongPress
{
    MessageItem *messageItem = (MessageItem *)self.modelItem;
    NSMutableArray *menuArray = [NSMutableArray array];
    if(messageItem.messageContent.messageType == UUMessageTypeText)
    {
        UIMenuItem *copyMenu = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(copyMessage)];
        [menuArray addObject:copyMenu];
    }
    if(!messageItem.isTmp)
    {
        NSInteger timeInterval = [[NSDate date] timeIntervalSince1970];
        if(timeInterval - messageItem.messageContent.timeInterval < 30)
        {
            UIMenuItem *revokeMenu = [[UIMenuItem alloc] initWithTitle:@"撤销" action:@selector(revokeMessage)];
            [menuArray addObject:revokeMenu];
        }
        UIMenuItem *deleteMenu = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(deleteMessage)];
        [menuArray addObject:deleteMenu];
    }
    else
    {
        if(messageItem.messageStatus == MessageStatusFailed)
        {
            UIMenuItem *resendItem = [[UIMenuItem alloc] initWithTitle:@"重发" action:@selector(onResendMessage)];
            [menuArray addObject:resendItem];
        }
    }
    
    if(ChatTypeParents == self.chatType && messageItem.from == UUMessageFromOther)
    {
        UIMenuItem *blackMenu = [[UIMenuItem alloc] initWithTitle:@"拉黑" action:@selector(addToBlackList)];
        [menuArray addObject:blackMenu];
    }
    
    if(menuArray.count > 0)
    {
        [self becomeFirstResponder];
        UIMenuController *menu = [UIMenuController sharedMenuController];
        [menu setMenuItems:menuArray];
        [menu setTargetRect:_contentButton.frame inView:self];
        [menu setMenuVisible:YES animated:YES];
    }
}

- (void)onContentButtonClicked
{
    MessageItem *messageItem = (MessageItem *)self.modelItem;
    if (messageItem.messageContent.messageType == UUMessageTypePicture)
    {
        UIImageView *backImageView = _contentButton.backImageView;
        UIImage *defaultImage = backImageView.image;
        if(defaultImage)
        {
            PhotoItem *photoItem = [messageItem.messageContent photoItem];
//            if(photoItem.originalUrl.length > 0)
//                [_contentButton.backImageView sd_setImageWithURL:[NSURL URLWithString:photoItem.originalUrl] placeholderImage:defaultImage];
            [UUImageAvatarBrowser showImage:_contentButton.backImageView withOriginalUrl:photoItem.originalUrl size:CGSizeMake(photoItem.width, photoItem.height)];
        }
    }
}

- (void)makeMaskView:(UIView *)view withImage:(UIImage *)image
{
    UIImageView *imageViewMask = [[UIImageView alloc] initWithImage:image];
    imageViewMask.frame = CGRectInset(view.frame, 0.0f, 0.0f);
    view.layer.mask = imageViewMask.layer;
}

+ (NSNumber *)cellHeight:(TNModelItem *)modelItem cellWidth:(NSInteger)width
{
    MessageItem *messageItem = (MessageItem *)modelItem;
    return @([messageItem cellHeight]);
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (BOOL)canPerformAction:(SEL)action
              withSender:(id)sender
{
    if (action == @selector(copyMessage) ||
        action == @selector(deleteMessage) ||
        action == @selector(revokeMessage) ||
        action == @selector(addToBlackList) ||
        action == @selector(onResendMessage))
        return YES;
    
    return NO;
}

-(void)copyMessage
{
    MessageItem *messageItem = (MessageItem *)self.modelItem;
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    pboard.string = messageItem.messageContent.text;
}

- (void)deleteMessage
{
    if([self.delegate respondsToSelector:@selector(onDeleteMessage:)])
        [self.delegate onDeleteMessage:(MessageItem *)self.modelItem];
}

- (void)revokeMessage
{
    if([self.delegate respondsToSelector:@selector(onRevokeMessage:)])
        [self.delegate onRevokeMessage:(MessageItem *)self.modelItem];
}

- (void)addToBlackList
{
    if([self.delegate respondsToSelector:@selector(onAddToBlackList)])
        [self.delegate onAddToBlackList];
}

- (void)onResendMessage
{
    if([self.delegate respondsToSelector:@selector(onResendMessage:)])
        [self.delegate onResendMessage:(MessageItem *)self.modelItem];
}
@end
