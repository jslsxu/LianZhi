//
//  VideoPlayerManager.h
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/9/15.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoPlayerManager : NSObject{
    BOOL    _isPlaying;
}
SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(VideoPlayerManager)
- (BOOL)isPlaying;
- (void)playWithUrl:(NSURL *)url;
@end
