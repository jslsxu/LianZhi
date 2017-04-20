//
//  VideoPlayerManager.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/9/15.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "VideoPlayerManager.h"
#import <MediaPlayer/MediaPlayer.h>
#import "VideoPlayerVC.h"
@implementation VideoPlayerManager
SYNTHESIZE_SINGLETON_FOR_CLASS(VideoPlayerManager)

- (BOOL)isPlaying{
    return [VideoPlayerVC isPlaying];
}

- (void)playWithUrl:(NSURL *)url{
    BOOL exist = NO;
    exist = url && [[NSFileManager defaultManager] fileExistsAtPath:url.path];
    if(exist){
        if(![VideoPlayerVC isPlaying]){
            VideoPlayerVC *playerVC = [[VideoPlayerVC alloc] initWithVideoUrl:url];
            [CurrentROOTNavigationVC presentViewController:playerVC animated:YES completion:nil];
        }
    }
    else{
        [ProgressHUD showHintText:@"视频不存在"];
    }
}


@end
