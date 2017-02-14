//
//  MessageCell.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/8/1.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "MessageCell.h"
#import "ChatBubbleContentView.h"
#import "ChatContentTextView.h"
#import "ChatContentImageView.h"
#import "ChatContentAudioView.h"
#import "ChatContentFaceView.h"
#import "ChatContentVideoView.h"
#import "ChatContentRevokeView.h"
#import "ChatContentReceiveGiftView.h"
#define kChatHMargin                8
#define kChatVMargin                5

#define kChatAvatarSize             32
#define kChatTimeLabelWidth         120
#define kChatTimeLabelHeight        15
#define kChatNameLabelHeight        15
#define kChatIndicatorWidth         30

@interface MessageCell ()
@property (nonatomic, strong)UIView<IChatContentView>*   chatContentView;
@end

@implementation MessageCell
- (instancetype)initWithModel:(MessageItem *)messageItem reuseID:(NSString *)reuseID{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    if(self){
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self setBackgroundColor:[UIColor clearColor]];
        self.width = kScreenWidth;
        _bgView = [[UIView alloc] initWithFrame:self.bounds];
        [_bgView setBackgroundColor:[UIColor whiteColor]];
        [_bgView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        [_bgView setAlpha:0.f];
        [self addSubview:_bgView];
        _messageItem = messageItem;
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.width - kChatTimeLabelWidth) / 2, kChatVMargin, kChatTimeLabelWidth, kChatTimeLabelHeight)];
        [_timeLabel setTextAlignment:NSTextAlignmentCenter];
        [_timeLabel setFont:[UIFont systemFontOfSize:12]];
        [_timeLabel setTextColor:[UIColor whiteColor]];
        [_timeLabel setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.2]];
        [_timeLabel.layer setCornerRadius:3];
        [_timeLabel.layer setMasksToBounds:YES];
        [self addSubview:_timeLabel];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.width - 10 * 2, kChatNameLabelHeight)];
        [_nameLabel setTextColor:[UIColor colorWithHexString:@"8f8f8f"]];
        [_nameLabel setFont:[UIFont systemFontOfSize:10]];
        [self addSubview:_nameLabel];
        
        _avatarView = [[AvatarView alloc] initWithFrame:CGRectMake(0, _nameLabel.bottom + 5, kChatAvatarSize, kChatAvatarSize)];
        [self addSubview:_avatarView];
        
        UILongPressGestureRecognizer *longpress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onAvatarLongPress)];
        [longpress setCancelsTouchesInView:YES];
        [longpress setMinimumPressDuration:1];
        [_avatarView addGestureRecognizer:longpress];
        
        UITapGestureRecognizer *avatarTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onAvatarClick)];
        [_avatarView addGestureRecognizer:avatarTapGesture];
        
//        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//        [_indicatorView setHidesWhenStopped:YES];
//        [self addSubview:_indicatorView];
        
        _sendFailImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        [_sendFailImageView setContentMode:UIViewContentModeCenter];
        [_sendFailImageView setImage:[UIImage imageNamed:@"SendFail"]];
        [_sendFailImageView setHidden:YES];
        [_sendFailImageView setUserInteractionEnabled:YES];
        [self addSubview:_sendFailImageView];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resendMessage)];
        [_sendFailImageView addGestureRecognizer:tapGesture];
        
        [self addSubview:self.chatContentView];
        [self updateContent];
    }
    return self;
}

- (void)setMessageItem:(MessageItem *)messageItem{
    _messageItem = messageItem;
    [self updateContent];
}

- (void)updateContent{
    CGFloat spaceYStart = kChatVMargin;
    _bgView.alpha = 0.f;
    [_avatarView sd_setImageWithURL:[NSURL URLWithString:self.messageItem.user.avatar]];
    if(self.messageItem.content.hideTime){
        [_timeLabel setHidden:YES];
    }
    else{
        [_timeLabel setHidden:NO];
        [_timeLabel setText:self.messageItem.content.timeStr];
        spaceYStart = _timeLabel.bottom + kChatVMargin;
    }
    if(self.messageItem.isMyMessage){
        [_avatarView setOrigin:CGPointMake(self.width - kChatHMargin - _avatarView.width, spaceYStart)];
    }
    else{
        [_avatarView setOrigin:CGPointMake(kChatHMargin, spaceYStart)];
    }
    if(self.messageItem.isMyMessage){
        [_nameLabel setTextAlignment:NSTextAlignmentRight];
        [_nameLabel setText:@"我自己"];
        [_nameLabel setOrigin:CGPointMake(_avatarView.left - 5 - _nameLabel.width, spaceYStart)];
    }
    else{
        [_nameLabel setTextAlignment:NSTextAlignmentLeft];
        [_nameLabel setText:self.messageItem.user.name];
        [_nameLabel setOrigin:CGPointMake(_avatarView.right + 5, spaceYStart)];
    }
    [_nameLabel setY:spaceYStart];
    spaceYStart += _nameLabel.height + kChatVMargin;
    BOOL receiveGift = self.messageItem.content.type == UUMessageTypeReceiveGift;
    [_avatarView setHidden:receiveGift];
    [_nameLabel setHidden:receiveGift];
    
    [self.chatContentView setMessageItem:_messageItem];
    if([self.chatContentView isKindOfClass:[ChatContentSendGiftView class]]){
        ChatContentSendGiftView *sendGiftView = (ChatContentSendGiftView *)self.chatContentView;
        [sendGiftView setReceiveGiftCallback:^(MessageItem *messageItem) {
            if([self.delegate respondsToSelector:@selector(onReceiveGift:)]){
                [self.delegate onReceiveGift:messageItem];
            }
        }];
    }
    if(self.messageItem.isMyMessage){
        [self.chatContentView setOrigin:CGPointMake(_avatarView.left - kChatHMargin - self.chatContentView.width, spaceYStart)];
        [_sendFailImageView setCenter:CGPointMake(self.chatContentView.left - kChatIndicatorWidth / 2, self.chatContentView.centerY)];
    }
    else{
        [self.chatContentView setOrigin:CGPointMake(_avatarView.right + kChatHMargin, spaceYStart)];
        [_sendFailImageView setCenter:CGPointMake(self.chatContentView.right + kChatIndicatorWidth / 2, self.chatContentView.centerY)];
    }
//    [_sendFailImageView setCenter:_indicatorView.center];
//    if(MessageStatusSending == _messageItem.messageStatus)
//    {
//        [_indicatorView startAnimating];
//    }
//    else
//    {
//        [_indicatorView stopAnimating];
//    }
    [_sendFailImageView setHidden:MessageStatusFailed != _messageItem.messageStatus];
}

- (UIView<IChatContentView> *)chatContentView{
    if(_chatContentView == nil){
        Class clazz = [MessageCell chatContentViewClassForMessage:self.messageItem];
        _chatContentView = [[clazz alloc] initWithModel:self.messageItem maxWidth:[MessageCell maxChatContentWidth]];
        UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onLongPress)];
        [longPressGesture setCancelsTouchesInView:YES];
        [longPressGesture setMinimumPressDuration:1];
        [_chatContentView addGestureRecognizer:longPressGesture];
        
    }
    return _chatContentView;
}

- (void)onAvatarLongPress{
    if(self.messageItem.from == UUMessageFromOther){
        if([self.delegate respondsToSelector:@selector(onLongPressAvatar:)]){
            [self.delegate onLongPressAvatar:self.messageItem];
        }
    }
}

- (void)onAvatarClick{
    if(self.messageItem.from == UUMessageFromOther){
        if([self.delegate respondsToSelector:@selector(onAvatarClicked:)]){
            [self.delegate onAvatarClicked:self.messageItem];
        }
    }
}

- (void)flashForAtMe{
//    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//        _bgView.alpha = 1.f;
//    } completion:^(BOOL finished) {
//        [UIView animateWithDuration:1 animations:^{
//            _bgView.alpha = 0.f;
//        }];
//    }];
}

- (void)onLongPress{
    NSMutableArray *menuArray = [NSMutableArray array];
    if(_messageItem.content.type == UUMessageTypeText)
    {
        UIMenuItem *copyMenu = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(copyMessage)];
        [menuArray addObject:copyMenu];
    }
    if(![_messageItem isLocalMessage])
    {
        NSInteger timeInterval = [[NSDate date] timeIntervalSince1970];
        if(timeInterval - _messageItem.content.ctime < 30)
        {
            if(_messageItem.from == UUMessageFromMe && (_messageItem.content.type != UUMessageTypeGift && _messageItem.content.type != UUMessageTypeReceiveGift && _messageItem.content.type != UUMessageTypeRevoked))
            {
                UIMenuItem *revokeMenu = [[UIMenuItem alloc] initWithTitle:@"撤回" action:@selector(revokeMessage)];
                [menuArray addObject:revokeMenu];
            }
        }
        
        UIMenuItem *deleteMenu = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(deleteMessage)];
        [menuArray addObject:deleteMenu];
    }
    else
    {
        if(_messageItem.messageStatus == MessageStatusFailed)
        {
            UIMenuItem *resendItem = [[UIMenuItem alloc] initWithTitle:@"重发" action:@selector(resendMessage)];
            [menuArray addObject:resendItem];
            UIMenuItem *deleteMenu = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(deleteMessage)];
            [menuArray addObject:deleteMenu];
        }
    }
    
    if(menuArray.count > 0)
    {
        [self becomeFirstResponder];
        UIMenuController *menu = [UIMenuController sharedMenuController];
        [menu setMenuItems:menuArray];
        [menu setTargetRect:self.chatContentView.frame inView:self];
        [menu setMenuVisible:YES animated:YES];
        
        if([self.delegate respondsToSelector:@selector(onMenuShow)]){
            [self.delegate onMenuShow];
        }
    }

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
        action == @selector(resendMessage))
        return YES;
    
    return NO;
}

-(void)copyMessage
{
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    pboard.string = self.messageItem.content.text;
}

- (void)deleteMessage
{
    if([self.delegate respondsToSelector:@selector(onDeleteMessage:)])
        [self.delegate onDeleteMessage:self.messageItem];
}

- (void)revokeMessage
{
    if([self.delegate respondsToSelector:@selector(onRevokeMessage:)])
        [self.delegate onRevokeMessage:self.messageItem];
}

- (void)resendMessage
{
    if([self.delegate respondsToSelector:@selector(onResendMessage:)])
        [self.delegate onResendMessage:self.messageItem];
}


+ (CGFloat)maxChatContentWidth{
    return kScreenWidth - (kChatAvatarSize + kChatHMargin * 2) * 2 - kChatIndicatorWidth;//减去菊花的宽度
}

+ (Class)chatContentViewClassForMessage:(MessageItem *)messageItem{
    Class clazz = nil;
    switch (messageItem.content.type) {
        case UUMessageTypeText:
            clazz = [ChatContentTextView class];
            break;
        case UUMessageTypePicture:
            clazz = [ChatContentImageView class];
            break;
        case UUMessageTypeVoice:
            clazz = [ChatContentAudioView class];
            break;
        case UUMessageTypeFace:
            clazz = [ChatContentFaceView class];
            break;
        case UUMessageTypeGift:
            clazz = [ChatContentSendGiftView class];
            break;
        case UUMessageTypeRevoked:
            clazz = [ChatContentRevokeView class];
            break;
        case UUMessageTypeReceiveGift:
            clazz = [ChatContentReceiveGiftView class];
            break;
        case UUMessageTypeVideo:
            clazz = [ChatContentVideoView class];
            break;
        default:
            clazz = [ChatContentTextView class];
            break;
    }
    return clazz;
}

+ (CGFloat)cellHeightForModel:(MessageItem *)messageItem{
    Class clazz = [MessageCell chatContentViewClassForMessage:messageItem];
    BOOL hideTime = messageItem.content.hideTime;
    CGFloat height = kChatVMargin;
    if(!hideTime){
        height += kChatVMargin + kChatTimeLabelHeight;
    }
    //名字
    height += kChatNameLabelHeight + kChatVMargin;
    //content height
    height += [clazz contentHeightForModel:messageItem maxWidth:[MessageCell maxChatContentWidth]];
    height += kChatVMargin;
    return height;
}

@end
