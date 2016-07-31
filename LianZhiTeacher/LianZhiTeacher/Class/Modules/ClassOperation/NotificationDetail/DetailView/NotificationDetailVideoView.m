//
//  NotificationDetailVideoView.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/7/30.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "NotificationDetailVideoView.h"
#import "KRVideoPlayerController.h"
@interface NotificationDetailVideoView ()
@property (nonatomic, strong)KRVideoPlayerController *playController;
@end

@implementation NotificationDetailVideoView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
//        _playController = [[KRVideoPlayerController alloc] initWithFrame:CGRectMake(10, 10, self.width - 10 * 2, (self.width - 10 * 2) * 2 / 3)];
//        [_playController setContentURL:[NSURL URLWithString:@"http://krtv.qiniudn.com/150522nextapp"]];
//        [_playController showInWindow];
//        
//        [self setHeight:_playController.view.height];
    }
    return self;
}

@end
