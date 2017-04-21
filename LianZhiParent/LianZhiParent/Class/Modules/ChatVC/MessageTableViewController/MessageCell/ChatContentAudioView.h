//
//  ChatAudioCell.h
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/8/1.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "ChatBubbleContentView.h"
#import "ChatVoiceButton.h"
@interface ChatContentAudioView : ChatBubbleContentView
{
    UILabel*            _durationLabel;
    ChatVoiceButton*    _playButton;
    UIView*             _redDot;
}
@end
