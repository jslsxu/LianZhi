//
//  HomeWorkAudioView.m
//  LianZhiTeacher
//
//  Created by jslsxu on 15/12/7.
//  Copyright © 2015年 jslsxu. All rights reserved.
//

#import "HomeWorkAudioView.h"

@implementation HomeWorkAudioView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self.layer setBorderWidth:2];
        [self.layer setBorderColor:[UIColor colorWithHexString:@"ebebeb"].CGColor];
        
        _audioImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HomeWorkAudioPlaying3"]];
        [_audioImageView setOrigin:CGPointMake(25, (self.height - _audioImageView.height) / 2)];
        [self addSubview:_audioImageView];
        
        _timeSpanLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_timeSpanLabel setTextColor:[UIColor colorWithHexString:@""]];
        [_timeSpanLabel setFont:[UIFont systemFontOfSize:13]];
        [self addSubview:_timeSpanLabel];
        
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteButton setFrame:CGRectMake(self.width - 30 - 50, (self.height - 50) / 2, 50, 50)];
        [_deleteButton addTarget:self action:@selector(onDeleteClicked) forControlEvents:UIControlEventTouchUpInside];
        [_deleteButton setImage:[UIImage imageNamed:@"HomeWorkAudioDelete"] forState:UIControlStateNormal];
        [self addSubview:_deleteButton];
        
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playButton setFrame:CGRectMake(_deleteButton.x - 15 - 50, (self.height - 50) / 2, 50, 50)];
        [_playButton setImage:[UIImage imageNamed:@"HomeWorkAudioPlay"] forState:UIControlStateNormal];
        [_playButton addTarget:self action:@selector(onPlayButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_playButton];
    }
    return self;
}

- (void)onDeleteClicked
{
    
}

- (void)onPlayButtonClicked
{
    if(!_isPlaying)
    {
        _isPlaying = YES;
        [_audioImageView setImage:[UIImage animatedImageNamed:@"HomeWorkAudioPlaying" duration:1.f]];
    }
    else
    {
        _isPlaying = NO;
        [_audioImageView setImage:[UIImage imageNamed:@"HomeWorkAudioPlaying3"]];
    }
}

@end
