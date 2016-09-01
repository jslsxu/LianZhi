//
//  MessageDetailItemCell.h
//  LianZhiParent
//
//  Created by jslsxu on 14/12/24.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "TNTableViewCell.h"
#import "MessageFromInfo.h"
#import "MessageVoiceButton.h"
extern NSString *const kMessageDeleteNotitication;
extern NSString *const kMessageDeleteModelItemKey;


@interface MessageDetailItemCell : TNTableViewCell
{
    UIView*                 _bgView;
    AvatarView*             _avatarView;
    UIButton*               _deleteButton;
    UILabel*                _nameLabel;
    UILabel*                _timeLabel;
    UILabel*                _contentLabel;
    UIView*                 _extraView;
    UIView*                 _sepLine;
    UIImageView*            _voiceImageView;
    UIImageView*            _videoImageView;
    UIImageView*            _photoImageView;
    UIImageView*            _rightArrow;
}
@property (nonatomic, strong)MessageFromInfo *fromInfo;
@property (nonatomic, copy)void (^deleteCallback)();
@end
