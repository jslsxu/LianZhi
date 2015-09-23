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
#define kTimeLabelHeight            20
#define kAvatarHMargin              8
#define kMessageCellVMargin         10
#define kFaceWith                   80
@interface MessageCell : TNTableViewCell
{
    UILabel*                    _timeLabel;
    UILabel*                    _nameLabel;
    AvatarView*                 _avatarView;
    UUMessageContentButton*     _contentButton;
    UILabel*                    _audioTimeLabel;
    ChatVoiceButton*            _playButton;
}
@end
