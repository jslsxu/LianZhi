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

@interface NotificationDetailView ()
@property (nonatomic, strong)NotificationDetailContentView*  contentView;
@property (nonatomic, strong)NotificationDetailVoiceView*    voiceView;
@property (nonatomic, strong)NotificationDetailVideoView*    videoView;
@property (nonatomic, strong)NotificationDetailPhotoView*    photoView;
@end
@implementation NotificationDetailView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self setBackgroundColor:[UIColor whiteColor]];
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        [_scrollView setShowsVerticalScrollIndicator:NO];
        [_scrollView setAlwaysBounceVertical:YES];
        [self addSubview:_scrollView];
        
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    self.contentView = [[NotificationDetailContentView alloc] initWithFrame:CGRectMake(0, 0, _scrollView.width, 0)];
    [_scrollView addSubview:self.contentView];
    
    self.voiceView = [[NotificationDetailVoiceView alloc] initWithFrame:CGRectMake(0, self.contentView.bottom, _scrollView.width, 0)];
    [_scrollView addSubview:self.voiceView];
    
    self.videoView = [[NotificationDetailVideoView alloc] initWithFrame:CGRectMake(0, self.voiceView.bottom, _scrollView.width, 0)];
    [_scrollView addSubview:self.videoView];
    
    self.photoView = [[NotificationDetailPhotoView alloc] initWithFrame:CGRectMake(0, self.videoView.bottom, _scrollView.width, 0)];
    [_scrollView addSubview:self.photoView];
}

- (void)adjustPosition{
    CGFloat spaceYStart = 0;
    [self.contentView setMessageDetailItem:self.notificationItem];
    spaceYStart = self.contentView.bottom;
    if([self.notificationItem hasAudio]){
        [self.voiceView setVoiceArray:@[self.notificationItem.voice]];
        [self.voiceView setTop:spaceYStart];
        spaceYStart = self.voiceView.bottom;
    }
    if([self.notificationItem hasVideo]){
        [self.videoView setVideoArray:@[self.notificationItem.video]];
        [self.videoView setTop:spaceYStart];
        spaceYStart = self.videoView.bottom;
    }
    [self.photoView setPhotoArray:self.notificationItem.pictures];
    [self.photoView setTop:spaceYStart];
    [_scrollView setContentSize:CGSizeMake(_scrollView.width, self.photoView.bottom)];
}

- (void)setNotificationItem:(MessageDetailItem *)notificationItem{
    _notificationItem = notificationItem;
    [self adjustPosition];
}

@end
