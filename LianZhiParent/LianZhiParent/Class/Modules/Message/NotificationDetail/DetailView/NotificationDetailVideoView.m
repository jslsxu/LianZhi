//
//  NotificationDetailVideoView.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/7/30.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "NotificationDetailVideoView.h"
#import "KRVideoPlayerController.h"

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
    NSURL *url;
    if(self.videoItem.localVideoPath.length > 0){
        url = [NSURL fileURLWithPath:self.videoItem.localVideoPath];
    }
    else{
        url = [NSURL URLWithString:self.videoItem.videoUrl];
    }
    MPMoviePlayerViewController *playerVC = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
    [CurrentROOTNavigationVC presentMoviePlayerViewControllerAnimated:playerVC];
}

- (void)onDeleteButtonClicked{
    if(self.deleteCallback){
        self.deleteCallback();
    }
}

@end


@interface NotificationDetailVideoView (){
    
}

@property (nonatomic, strong)NSMutableArray*    videoViewArray;
@end

@implementation NotificationDetailVideoView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.videoViewArray = [NSMutableArray array];
        
        [self setClipsToBounds:YES];
    }
    return self;
}

- (void)setVideoArray:(NSArray *)videoArray{
    _videoArray = videoArray;
    [_videoViewArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_videoViewArray removeAllObjects];
    
    CGFloat height = 0;
    NSInteger margin = 10;
    NSInteger start = 0;
    if(_videoArray.count % 2 == 1){
        start = 1;
        VideoItem *videoItem = _videoArray[0];
        VideoItemView*  videoItemView = [[VideoItemView alloc] initWithFrame:CGRectMake(margin, 0, self.width - margin * 2, (self.width - margin * 2) * 2 / 3 )];
        [videoItemView setVideoItem:videoItem];
        [videoItemView setVideoViewType:VideoViewTypePreview];
        [_videoViewArray addObject:videoItemView];
        [self addSubview:videoItemView];
        height += videoItemView.height + margin;
    }
    CGFloat itemWidth = (self.width - margin * 3) / 2;
    CGFloat itemHeight = itemWidth * 2 / 3;
    for (NSInteger i = start; i < _videoArray.count; i++) {
        VideoItem *videoItem = _videoArray[i];
        NSInteger row = (i - start) / 2;
        NSInteger column = (i - start) % 2;
        VideoItemView*  videoItemView = [[VideoItemView alloc] initWithFrame:CGRectMake(margin + (itemWidth + margin) * column, height + (itemHeight + margin) * row, itemWidth, itemHeight)];
        [videoItemView setVideoItem:videoItem];
        [videoItemView setVideoViewType:VideoViewTypePreview];
        [_videoViewArray addObject:videoItemView];
        [self addSubview:videoItemView];
    }
    NSInteger row = (_videoArray.count - start + 1) / 2;
    height += (itemHeight + margin) * row;
    [self setHeight:height];

}

@end
