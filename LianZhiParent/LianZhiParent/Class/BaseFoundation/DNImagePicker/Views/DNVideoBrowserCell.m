//
//  DNVideoBrowserCell.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/8/31.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "DNVideoBrowserCell.h"
#import "DNPhotoBrowser.h"
@interface DNVideoBrowserCell()
@property (nonatomic, strong)UIImageView*   imageView;
@property (nonatomic, strong)UIImageView*   playView;
@property (nonatomic, strong)AVPlayer*      player;
@property (nonatomic, strong)AVPlayerItem*  playItem;
@property (nonatomic, strong)AVPlayerLayer* playerlayer;
@property (nonatomic, assign)BOOL           isPlaying;
@end

@implementation DNVideoBrowserCell

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self setClipsToBounds:YES];
        [self addSubview:self.imageView];
        [self addSubview:self.playView];
        [self.playView setCenter:CGPointMake(self.width / 2, self.height / 2)];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onPlayEnd) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    }
    return self;
}

- (UIImageView *)imageView{
    if(!_imageView){
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [_imageView setClipsToBounds:YES];
        [_imageView setContentMode:UIViewContentModeScaleAspectFit];
        [_imageView setUserInteractionEnabled:YES];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap)];
        [_imageView addGestureRecognizer:tapGesture];
    }
    return _imageView;
}

- (UIImageView *)playView{
    if(!_playView){
        _playView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"preview_play"]];
    }
    return _playView;
}

- (void)setAsset:(ALAsset *)asset{
    if(_asset != asset){
        _asset = asset;
        UIImage *img = [UIImage imageWithCGImage:[[self.asset defaultRepresentation] fullScreenImage]];
        [self.imageView setImage:img];
    }
}

- (void)stopPlay{
    self.isPlaying = NO;
    [self.playView setHidden:NO];
    [self.player pause];
    self.player = nil;
    [self.playerlayer removeFromSuperlayer];
    self.playerlayer = nil;
    self.playItem = nil;
}

- (void)startPlay{
    [self.playView setHidden:YES];
    AVAsset *avAsset = [AVAsset assetWithURL:[self.asset.defaultRepresentation url]];
    self.playItem = [[AVPlayerItem alloc] initWithAsset:avAsset];
    self.player = [[AVPlayer alloc] init];
    self.playerlayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    [self.playerlayer setFrame:[[self.imageView layer] bounds]];
    [self.imageView.layer addSublayer:self.playerlayer];
    [self.player replaceCurrentItemWithPlayerItem:self.playItem];
    [self.player play];
    self.isPlaying = YES;
}

- (void)onTap{
    if(self.isPlaying){
        [self stopPlay];
        if([self.photoBrowser areControlsHidden]){
             [self.photoBrowser performSelector:@selector(toggleControls) withObject:nil afterDelay:0.2];
        }
    }
    else{
        [self startPlay];
        if(![self.photoBrowser areControlsHidden]){
             [self.photoBrowser performSelector:@selector(toggleControls) withObject:nil afterDelay:0.2];
        }
    }
}

- (void)onPlayEnd{
    [self stopPlay];
    if([self.photoBrowser areControlsHidden]){
        [self.photoBrowser performSelector:@selector(toggleControls) withObject:nil afterDelay:0.2];
    }
}
@end
