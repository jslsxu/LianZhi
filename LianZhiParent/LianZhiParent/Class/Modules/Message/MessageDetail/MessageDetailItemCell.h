//
//  MessageDetailItemCell.h
//  LianZhiParent
//
//  Created by jslsxu on 14/12/24.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "TNTableViewCell.h"
#import "MessageDetailModel.h"
#import "MessageVoiceButton.h"

extern NSString *const kMessageDeleteNotitication;
extern NSString *const kMessageDeleteModelItemKey;

@interface MessageDetailItemCell : TNTableViewCell
{
    UIImageView*            _bgImageView;
    UILabel*                _contentLabel;
    MessageVoiceButton*     _voiceButton;
    UIView*                 _sepLine;
    UIButton*               _deleteButton;
    UILabel*                _timeLabel;
}
@end
