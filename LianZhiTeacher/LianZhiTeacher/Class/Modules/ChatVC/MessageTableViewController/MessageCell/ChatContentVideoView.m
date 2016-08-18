//
//  ChatVideoCell.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/8/1.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "ChatContentVideoView.h"
#import <MediaPlayer/MediaPlayer.h>
#import "NHFileServer.h"
#import "SSPieProgressView.h"
#define kVideoMaxSize               140
@interface ChatContentVideoView (){
    UIImageView*        _coverImageView;
    UIImageView*        _playView;
    SSPieProgressView* _progressView;
    UILabel*            _durationLabel;
    MBProgressHUD*      _progressHUD;
}

@end

@implementation ChatContentVideoView

- (instancetype)initWithModel:(MessageItem *)messageItem maxWidth:(CGFloat)maxWidth{
    self = [super initWithModel:messageItem maxWidth:maxWidth];
    if(self){
        _coverImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [_coverImageView setContentMode:UIViewContentModeScaleAspectFill];
        [_coverImageView setUserInteractionEnabled:YES];
        [_coverImageView setClipsToBounds:YES];
        [_bubbleBackgroundView addSubview:_coverImageView];
        
        _playView = [[UIImageView alloc] initWithFrame:_coverImageView.bounds];
        [_playView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        [_playView setImage:[UIImage imageNamed:@"play_big"]];
        [_playView setContentMode:UIViewContentModeCenter];
        [_playView setBackgroundColor:[UIColor clearColor]];
        [_coverImageView addSubview:_playView];
        
        _progressView = [[SSPieProgressView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [_progressView setHidden:YES];
        [_coverImageView addSubview:_progressView];
        
        _durationLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_durationLabel setTextColor:[UIColor whiteColor]];
        [_durationLabel setFont:[UIFont systemFontOfSize:12]];
        [_coverImageView addSubview:_durationLabel];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onPlayClicked)];
        [_bubbleBackgroundView addGestureRecognizer:tapGesture];
    }
    return self;
}

- (void)onPlayClicked{
    VideoItem *videoItem = self.messageItem.content.exinfo.video;
    if(self.messageItem.isLocalMessage){
        NSURL* url = [NSURL fileURLWithPath:videoItem.videoUrl];
        [self showPlayerWithUrl:url];
    }
    else{
        [_playView setHidden:YES];
        [_progressView setHidden:NO];
        [LZVideoCacheManager videoForUrl:videoItem.videoUrl progress:^(CGFloat progress) {
            [_progressView setProgress:progress];
        } complete:^(NSURL * fileURL) {
            [_progressView setHidden:YES];
            [_playView setHidden:NO];
            [self showPlayerWithUrl:fileURL];
        } fail:^(NSError *error) {
            [_progressView setHidden:YES];
            [_playView setHidden:NO];
        }];
    }
}

- (void)showPlayerWithUrl:(NSURL *)url{
    if(url){
        MPMoviePlayerViewController *playerVC = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
        [CurrentROOTNavigationVC presentMoviePlayerViewControllerAnimated:playerVC];
    }
    else{
        [ProgressHUD showHintText:@"视频不存在"];
    }
}

- (void)setMessageItem:(MessageItem *)messageItem{
    [super setMessageItem:messageItem];
    VideoItem *videoItem = messageItem.content.exinfo.video;
    if(videoItem.coverWidth == 0 || videoItem.coverHeight == 0){
        [_bubbleBackgroundView setSize:CGSizeMake(kVideoMaxSize, kVideoMaxSize)];
    }
    else{
        if(videoItem.coverWidth > videoItem.coverHeight)
            [_bubbleBackgroundView setSize:CGSizeMake(kVideoMaxSize, kVideoMaxSize * videoItem.coverHeight / videoItem.coverWidth)];
        else
            [_bubbleBackgroundView setSize:CGSizeMake(kVideoMaxSize * videoItem.coverWidth / videoItem.coverHeight, kVideoMaxSize)];
    }
    [_coverImageView setFrame:_bubbleBackgroundView.bounds];
    [_playView setFrame:_coverImageView.bounds];
    [_progressView setCenter:CGPointMake(_coverImageView.width / 2, _coverImageView.height / 2)];
    [_progressView setProgress:0];
    [_progressView setHidden:YES];
    [_playView setHidden:NO];
    [self makeMaskView:_coverImageView withImage:[_bubbleBackgroundView image]];
    [_durationLabel setText:[Utility formatStringForTime:videoItem.videoTime]];
    [_durationLabel sizeToFit];
    [_durationLabel setOrigin:CGPointMake(_coverImageView.width - _durationLabel.width - 15, _coverImageView.height - _durationLabel.height - 5)];
    if(self.messageItem.isLocalMessage){
        NSData *imageData = [NSData dataWithContentsOfFile:videoItem.coverUrl];
        UIImage *image = [UIImage imageWithData:imageData];
        [_coverImageView setImage:image];
    }
    else{
        [_coverImageView sd_setImageWithURL:[NSURL URLWithString:videoItem.coverUrl] placeholderImage:nil];
    }
    [self setSize:_bubbleBackgroundView.size];
}

- (void)makeMaskView:(UIView *)view withImage:(UIImage *)image
{
    UIImageView *imageViewMask = [[UIImageView alloc] initWithImage:image];
    imageViewMask.frame = CGRectInset(view.frame, 0.0f, 0.0f);
    view.layer.mask = imageViewMask.layer;
}


+ (CGFloat)contentHeightForModel:(MessageItem *)messageItem maxWidth:(CGFloat)maxWidth{
    VideoItem *videoItem = messageItem.content.exinfo.video;
    if(videoItem.coverWidth == 0 || videoItem.coverHeight == 0){
        return kVideoMaxSize;
    }
    else{
        if(videoItem.coverWidth > videoItem.coverHeight)
            return kVideoMaxSize * videoItem.coverHeight / videoItem.coverWidth;
        else
            return kVideoMaxSize;
    }
}

@end
