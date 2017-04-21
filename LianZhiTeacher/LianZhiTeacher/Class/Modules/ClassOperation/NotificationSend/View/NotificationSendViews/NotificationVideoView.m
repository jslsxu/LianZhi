//
//  NotificationVideoView.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/7/29.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "NotificationVideoView.h"
#import <MediaPlayer/MediaPlayer.h>
#import "VideoPlayerManager.h"
@interface VideoItemView ()
@property (nonatomic, strong)UIImageView *coverImageView;
@property (nonatomic, strong)UIView   *darkCoverView;
@property (nonatomic, strong)SSPieProgressView *progressView;
@property (nonatomic, strong)UIButton*    deleteButton;
@property (nonatomic, strong)UIButton* playButton;
@end
@implementation VideoItemView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        _coverImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [_coverImageView setBackgroundColor:[UIColor colorWithHexString:@"dddddd"]];
        [_coverImageView setContentMode:UIViewContentModeScaleAspectFill];
        [_coverImageView setClipsToBounds:YES];
        [self addSubview:_coverImageView];
        
        _darkCoverView = [[UIView alloc] initWithFrame:self.bounds];
        [_darkCoverView setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.3]];
        [self addSubview:_darkCoverView];
        
        _progressView = [[SSPieProgressView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [_progressView setCenter:CGPointMake(self.width / 2, self.height / 2)];
        [_progressView setHidden:YES];
        [_coverImageView addSubview:_progressView];
        
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playButton addTarget:self action:@selector(onPlayButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_playButton setImage:[UIImage imageNamed:@"play_small"] forState:UIControlStateNormal];
        [self addSubview:_playButton];
        
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteButton setFrame:CGRectMake(self.width - 30, 0, 30, 30)];
        [_deleteButton addTarget:self action:@selector(onDeleteButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_deleteButton setImage:[UIImage imageNamed:@"media_delete"] forState:UIControlStateNormal];
        [self addSubview:_deleteButton];
    }
    return self;
}

- (void)setVideoViewType:(VideoViewType)videoViewType{
    _videoViewType = videoViewType;
    if(_videoViewType == VideoViewTypeEdit){
        [_deleteButton setHidden:NO];
        [_playButton setImage:[UIImage imageNamed:@"play_small"] forState:UIControlStateNormal];
    }
    else{
        [_deleteButton setHidden:YES];
        [_playButton setImage:[UIImage imageNamed:@"preview_play"] forState:UIControlStateNormal];
    }
}

- (void)setVideoItem:(VideoItem *)videoItem{
    _videoItem = videoItem;
    if(videoItem.coverImage)
        [_coverImageView setImage:videoItem.coverImage];
    else{
        [_coverImageView sd_setImageWithURL:[NSURL URLWithString:videoItem.coverUrl] placeholderImage:nil];
    }
    [_playButton setFrame:self.bounds];
}

- (void)onPlayButtonClicked{
    if([[MLAmrPlayer shareInstance] isPlaying]){
        [[MLAmrPlayer shareInstance] stopPlaying];
    }
    NSURL *url;
    if(self.videoItem.isLocal){
        url = [NSURL fileURLWithPath:self.videoItem.videoUrl];
        [self showPlayerWithUrl:url];
    }
    else{
        @weakify(self)
        [_playButton setHidden:YES];
        [_progressView setHidden:NO];
        [LZVideoCacheManager videoForUrl:self.videoItem.videoUrl progress:^(CGFloat progress) {
            @strongify(self)
            [self.progressView setProgress:progress];
        } complete:^(NSURL * fileURL) {
            @strongify(self)
            [self.progressView setHidden:YES];
            [self.playButton setHidden:NO];
            [self showPlayerWithUrl:fileURL];
        } fail:^(NSError *error) {
            @strongify(self)
            [self.progressView setHidden:YES];
            [self.playButton setHidden:NO];
        }];
    }
}

- (void)showPlayerWithUrl:(NSURL *)url{
    [[VideoPlayerManager sharedInstance] playWithUrl:url];
}

- (void)onDeleteButtonClicked{
    if(self.deleteCallback){
        self.deleteCallback();
    }
}

@end

@interface NotificationVideoView (){
    UILabel*            _titleLabel;
    NSMutableArray*     _videoViewArray;
    UIView*             _sepLine;
}

@end

@implementation NotificationVideoView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self setClipsToBounds:YES];
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.width - 10 * 2, 40)];
        [_titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_titleLabel setTextColor:[UIColor colorWithHexString:@"333333"]];
        [_titleLabel setText:@"视频:"];
        [self addSubview:_titleLabel];
        
        _videoViewArray = [NSMutableArray array];

        _sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, kLineHeight)];
        [_sepLine setBackgroundColor:kSepLineColor];
        [self addSubview:_sepLine];
        
    }
    return self;
}

- (void)setVideoArray:(NSMutableArray *)videoArray{
    _videoArray = videoArray;
    [_videoViewArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_videoViewArray removeAllObjects];
    NSInteger itemWidth = (self.width - 10 * 4) / 3;
    NSInteger row = 0;
    NSInteger column;
    for (NSInteger i = 0; i < _videoArray.count; i++) {
        row = i / 3;
        column = i % 3;
        VideoItem *videoItem = _videoArray[i];
        VideoItemView *videoItemView = [[VideoItemView alloc] initWithFrame:CGRectMake(10 + (10 + itemWidth) * column, _titleLabel.bottom + (itemWidth + 10) * row, itemWidth, itemWidth)];
        [videoItemView setVideoItem:videoItem];
        @weakify(self)
        [videoItemView setDeleteCallback:^{
            @strongify(self)
            [self deleteVideo:videoItem];
        }];
        [_videoViewArray addObject:videoItemView];
        [self addSubview:videoItemView];
    }
    
    if(_videoArray.count == 0){
        [self setHeight:0];
    }
    else{
        row = (_videoArray.count + 2) / 3;
        [self setHeight:_titleLabel.height + (itemWidth + 10) * row];
    }
    [_sepLine setY:self.height - kLineHeight];
}

- (void)deleteVideo:(VideoItem *)videoItem{
    if(self.deleteDataCallback){
        self.deleteDataCallback(videoItem);
    }
}

@end
