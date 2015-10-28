//
//  MessageCell.h
//  LianZhiParent
//
//  Created by jslsxu on 15/9/20.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "TNTableViewCell.h"
#import "UUMessageContentButton.h"
#import "MessageItem.h"
#import "ChatVoiceButton.h"

#define kTimeLabelHeight            16

#define kAvatarHMargin              8
#define kMessageCellVMargin         10
#define kFaceWith                   100
#define kFaceHeight                 80

@protocol MessageCellDelegate <NSObject>
- (void)onRevokeMessage:(MessageItem *)messageItem;
- (void)onDeleteMessage:(MessageItem *)messageItem;
- (void)onResendMessage:(MessageItem *)messageItem;
- (void)onAddToBlackList;
@end
@interface MessageCell : TNTableViewCell
{
    UIActivityIndicatorView*    _indicatorView;
    UIImageView*                _sendFailImageView;
    UILabel*                    _timeLabel;
    UILabel*                    _nameLabel;
    AvatarView*                 _avatarView;
    UUMessageContentButton*     _contentButton;
    UILabel*                    _audioTimeLabel;
    ChatVoiceButton*          _playButton;
    UILabel*                    _revokeMessageLabel;
}
@property (nonatomic, assign)ChatType chatType;
@property (nonatomic, weak)id<MessageCellDelegate> delegate;
@end
