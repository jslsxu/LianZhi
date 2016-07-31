//
//  NotificationDetailView.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/7/30.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "NotificationDetailView.h"
#import "NotificationDetailContentView.h"
#import "NotificationDetailVoiceView.h"
#import "NotificationDetailPhotoView.h"
#import "NotificationDetailVideoView.h"
@implementation NotificationDetailView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self setBackgroundColor:[UIColor whiteColor]];
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        [_scrollView setShowsVerticalScrollIndicator:NO];
        [self addSubview:_scrollView];
        
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    NotificationDetailContentView*  contentView = [[NotificationDetailContentView alloc] initWithFrame:CGRectMake(0, 0, _scrollView.width, 0)];
    [_scrollView addSubview:contentView];
    
    NotificationDetailVoiceView*    voiceView = [[NotificationDetailVoiceView alloc] initWithFrame:CGRectMake(0, contentView.bottom, _scrollView.width, 0)];
    [_scrollView addSubview:voiceView];
    
    NotificationDetailVideoView*    videoView = [[NotificationDetailVideoView alloc] initWithFrame:CGRectMake(0, voiceView.bottom, _scrollView.width, 0)];
    [_scrollView addSubview:videoView];
    
    NotificationDetailPhotoView*    photoView = [[NotificationDetailPhotoView alloc] initWithFrame:CGRectMake(0, videoView.bottom, _scrollView.width, 0)];
    [photoView setPhotoArray:@[@"",@"",@"",@"",@""]];
    [_scrollView addSubview:photoView];
    
    [_scrollView setContentSize:CGSizeMake(_scrollView.width, photoView.bottom)];
}

@end
