//
//  ChatVoiceButton.m
//  LianZhiParent
//
//  Created by jslsxu on 15/9/21.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "ChatVoiceButton.h"

@implementation ChatVoiceButton

- (void)dealloc
{
    if([MLAmrPlayer shareInstance].isPlaying){
        [[MLAmrPlayer shareInstance] stopPlaying];
    }
}

- (void)updatePlayingSignImage
{
    if (self.voiceState==MLPlayVoiceButtonStateDownloading)
    {
        self.playingSignImageView.image = nil;
        return;
    }
    
    NSString *prefix = self.type==MLPlayVoiceButtonTypeRight?@"AudioPlayMe":@"AudioPlayOther";
    if ([self isVoicePlaying]) {
        self.playingSignImageView.image = [UIImage animatedImageNamed:prefix duration:1.0f];
    }else{
        self.playingSignImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@3",prefix]];
    }
}
@end
