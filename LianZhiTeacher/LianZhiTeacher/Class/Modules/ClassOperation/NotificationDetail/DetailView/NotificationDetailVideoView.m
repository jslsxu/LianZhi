//
//  NotificationDetailVideoView.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/7/30.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "NotificationDetailVideoView.h"
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
