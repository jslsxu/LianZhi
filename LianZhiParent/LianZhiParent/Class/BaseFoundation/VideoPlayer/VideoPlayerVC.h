//
//  VideoPlayerVC.h
//  LianZhiTeacher
//
//  Created by jslsxu on 2017/4/20.
//  Copyright © 2017年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"

@interface VideoPlayerVC : TNBaseViewController
+ (BOOL)isPlaying;
- (instancetype)initWithVideoUrl:(NSURL *)videoUrl;
@end
