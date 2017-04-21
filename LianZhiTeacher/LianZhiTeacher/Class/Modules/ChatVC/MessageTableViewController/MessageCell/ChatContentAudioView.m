//
//  ChatAudioCell.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/8/1.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "ChatContentAudioView.h"
#import "AudioManager.h"
#define kDurationWidth          50

@implementation ChatContentAudioView

- (instancetype)initWithModel:(MessageItem *)messageItem maxWidth:(CGFloat)maxWidth{
    self = [super initWithModel:messageItem maxWidth:maxWidth];
    if(self){
        _durationLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_durationLabel setTextColor:[UIColor colorWithHexString:@"999999"]];
        [_durationLabel setFont:[UIFont systemFontOfSize:14]];
        [self addSubview:_durationLabel];
        
        _playButton = [[ChatVoiceButton alloc] init];
        [_playButton addTarget:self action:@selector(onAudioClicked) forControlEvents:UIControlEventTouchUpInside];
        [_bubbleBackgroundView addSubview:_playButton];
        
        _redDot = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 4, 4)];
        [_redDot setBackgroundColor:kRedColor];
        [_redDot.layer setCornerRadius:2];
        [_redDot.layer setMasksToBounds:YES];
        [self addSubview:_redDot];
    }
    return self;
}

- (void)onAudioClicked{
    AudioItem *audioItem = self.messageItem.content.exinfo.voice;
    if(self.messageItem.isLocalMessage){
        [_playButton setVoiceWithURL:[NSURL fileURLWithPath:audioItem.audioUrl] withAutoPlay:YES];
    }
    else{
        [_playButton setVoiceWithURL:[NSURL URLWithString:audioItem.audioUrl] withAutoPlay:YES];
        [[AudioManager sharedInstance] readAudio:audioItem.audioUrl];
        [_redDot setHidden:YES];
    }
}

- (void)setMessageItem:(MessageItem *)messageItem{
    [super setMessageItem:messageItem];
    CGFloat playWidth = (_maxWidth - kDurationWidth - 60) * (messageItem.content.exinfo.voice.timeSpan - 2) / (120 - 2) + 60;
    [_bubbleBackgroundView setSize:CGSizeMake(playWidth, 32)];
    [_playButton setFrame:_bubbleBackgroundView.bounds];
    [_durationLabel setText:[Utility formatStringForTime:messageItem.content.exinfo.voice.timeSpan]];
    [_durationLabel sizeToFit];
    [self setSize:CGSizeMake(_bubbleBackgroundView.width + 5 + _durationLabel.width + 5, 32)];
    [_redDot setHidden:YES];
    if(messageItem.from == UUMessageFromMe)
    {
        _playButton.type = MLPlayVoiceButtonTypeRight;
        [_durationLabel setOrigin:CGPointMake(0, (self.height - _durationLabel.height) / 2)];
        [_bubbleBackgroundView setOrigin:CGPointMake(_durationLabel.right + 5, 0)];
    }
    else
    {
        if(![[AudioManager sharedInstance] audioHasBeenRead:messageItem.content.exinfo.voice.audioUrl]){
            [_redDot setHidden:NO];
        }
        _playButton.type = MLPlayVoiceButtonTypeLeft;
        [_bubbleBackgroundView setOrigin:CGPointMake(0, 0)];
        [_durationLabel setOrigin:CGPointMake(_bubbleBackgroundView.right + 5, (self.height - _durationLabel.height) / 2)];
        [_redDot setOrigin:CGPointMake(_durationLabel.right, _durationLabel.top)];
    }
}

+ (CGFloat)contentHeightForModel:(MessageItem *)messageItem maxWidth:(CGFloat)maxWidth{
    return 32;
}

@end
