//
//  VideoPlayerManager.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/9/15.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "VideoPlayerManager.h"
#import <MediaPlayer/MediaPlayer.h>

@implementation VideoPlayerManager
SYNTHESIZE_SINGLETON_FOR_CLASS(VideoPlayerManager)
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)isPlaying{
    return _isPlaying;
}

- (void)playWithUrl:(NSURL *)url{
    BOOL exist = NO;
    exist = url && [[NSFileManager defaultManager] fileExistsAtPath:url.path];
    if(exist){
        if(!_isPlaying){
            _isPlaying = YES;
            MPMoviePlayerViewController *playerVC = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
            [CurrentROOTNavigationVC presentMoviePlayerViewControllerAnimated:playerVC];
            
            [[NSNotificationCenter defaultCenter] removeObserver:playerVC
                                                            name:MPMoviePlayerPlaybackDidFinishNotification object:playerVC.moviePlayer];
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(videoFinished:) name:MPMoviePlayerPlaybackDidFinishNotification object:playerVC.moviePlayer];
        }
    }
    else{
        [ProgressHUD showHintText:@"视频不存在"];
    }
}

- (void)videoFinished:(NSNotification *)notification{
    _isPlaying = NO;
//    NSInteger value = [[notification.userInfo valueForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey] intValue];
//    if (value == MPMovieFinishReasonUserExited) {
        [CurrentROOTNavigationVC dismissMoviePlayerViewControllerAnimated];
//    }
     [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
