//
//  VideoPlayerVC.m
//  LianZhiTeacher
//
//  Created by jslsxu on 2017/4/20.
//  Copyright © 2017年 jslsxu. All rights reserved.
//

#import "VideoPlayerVC.h"

static BOOL isVideoPlaying = NO;

@interface VideoPlayerVC ()
@property (nonatomic, strong)NSURL* url;
@property (nonatomic, strong)AVPlayerItem *playerItem;
@property (nonatomic, strong)AVPlayer* player;
@property (nonatomic, strong)AVPlayerLayer* playerLayer;
@property (nonatomic, strong)UIView* playerView;
@property (nonatomic, strong)UIView* actionView;
@property (nonatomic, strong)UIButton* bottomPlayButton;
@property (nonatomic, strong)UISlider* slider;
@property (nonatomic, strong)UILabel* leftTimeLabel;
@property (nonatomic, strong)UILabel* rightTimeLabel;
@property (nonatomic, strong)id timeObserver;
@property (nonatomic, assign)BOOL playerPlaying;
@end

@implementation VideoPlayerVC

+ (BOOL)isPlaying{
    return isVideoPlaying;
}

- (instancetype)initWithVideoUrl:(NSURL *)videoUrl{
    self = [super init];
    if(self){
        self.url = videoUrl;
    }
    return self;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.player removeTimeObserver:self.timeObserver];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    self.player = [[AVPlayer alloc] initWithPlayerItem:[self playerItem]];
    self.player.volume = 1.0f;
    
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    [self.playerLayer setFrame:self.view.bounds];
    [self.playerLayer setVideoGravity:AVLayerVideoGravityResizeAspect];
    [self.playerView.layer addSublayer:self.playerLayer];
    [self.view addSubview:self.playerView];
    [self.view addSubview:self.actionView];
    
    [self addObserver];
    [self playOrStop];
}

- (AVPlayerItem *)playerItem{
    if(_playerItem == nil){
        _playerItem = [AVPlayerItem playerItemWithURL:self.url];
    }
    return _playerItem;
}

- (UIView *)playerView{
    if(_playerView == nil){
        _playerView = [[UIView alloc] initWithFrame:self.view.bounds];
        
    }
    return _playerView;
}

- (UIView *)actionView{
    if(_actionView == nil){
        _actionView = [[UIView alloc] initWithFrame:self.view.bounds];
        
        UIButton* cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelButton setFrame:CGRectMake(0, 0, 60, 60)];
        [cancelButton setImage:[UIImage imageNamed:@"ActionCancel"] forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [_actionView addSubview:cancelButton];
        
        UIView* bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height - 70, self.view.width, 70)];
        [_actionView addSubview:bottomView];
        
        self.bottomPlayButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.bottomPlayButton setImage:[UIImage imageNamed:@"SmallPause"] forState:UIControlStateNormal];
        [self.bottomPlayButton addTarget:self action:@selector(playOrStop) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomPlayButton setFrame:CGRectMake(10, 10, 40, 50)];
        [bottomView addSubview:self.bottomPlayButton];
        
        self.leftTimeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.leftTimeLabel setFont:[UIFont systemFontOfSize:14]];
        [self.leftTimeLabel setTextColor:[UIColor whiteColor]];
        [self.leftTimeLabel setText:@"0:00"];
        [self.leftTimeLabel sizeToFit];
        [self.leftTimeLabel setOrigin:CGPointMake(self.bottomPlayButton.right + 10, (bottomView.height - self.leftTimeLabel.height) / 2)];
        [bottomView addSubview:self.leftTimeLabel];
    
        AVAsset* asset = self.playerItem.asset;
        CMTime duration = asset.duration;
        float videoLong = CMTimeGetSeconds(duration);
        NSInteger seconds = ceilf(videoLong);
        NSString *videoLengthStr = [NSString stringWithFormat:@"0:%02zd", seconds];
        self.rightTimeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.rightTimeLabel setFont:[UIFont systemFontOfSize:14]];
        [self.rightTimeLabel setTextColor:[UIColor whiteColor]];
        [self.rightTimeLabel setText:videoLengthStr];
        [self.rightTimeLabel sizeToFit];
        [self.rightTimeLabel setOrigin:CGPointMake(bottomView.width - 10 - self.rightTimeLabel.width, (bottomView.height - self.rightTimeLabel.height) / 2)];
        [bottomView addSubview:self.rightTimeLabel];
        
        self.slider = [[UISlider alloc] initWithFrame:CGRectMake(self.leftTimeLabel.right + 10, (bottomView.height - 2) / 2, self.rightTimeLabel.left - 10 - (self.leftTimeLabel.right + 10), 2)];
        [self.slider setMaximumValue:videoLong];
        [self.slider setMinimumValue:0];
        [self.slider setUserInteractionEnabled:NO];
        [self.slider setBackgroundColor:[UIColor whiteColor]];
        [self.slider setMinimumTrackTintColor:[UIColor whiteColor]];
        [self.slider setThumbImage:[UIImage imageNamed:@"ProgressThumbnail"] forState:UIControlStateNormal];
        [bottomView addSubview:self.slider];
        
        UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onLongPress:)];
        [longGesture setMinimumPressDuration:1];
        [_actionView addGestureRecognizer:longGesture];
    }
    return _actionView;
}


- (void)playOrStop{
    self.playerPlaying = !self.playerPlaying;
    if(self.playerPlaying){
        [self.player play];
        [self.bottomPlayButton setImage:[UIImage imageNamed:@"SmallPause"] forState:UIControlStateNormal];
    }
    else{
        [self.player pause];
        [self.bottomPlayButton setImage:[UIImage imageNamed:@"SmallPlay"] forState:UIControlStateNormal];
    }
}

- (void)addObserver{
    
    //监控播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
    
    //监控时间进度
    __weak typeof(self) wself = self;
    self.timeObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 30) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        float current = CMTimeGetSeconds(time);
        [wself.slider setValue:current animated:YES];
    }];
}


- (void)removeObserver{
    [self.player.currentItem removeObserver:self  forKeyPath:@"status"];
    [self.player.currentItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

- (void)playbackFinished{
    self.playerPlaying = NO;
    [self.slider setValue:0.f];
    [self.bottomPlayButton setImage:[UIImage imageNamed:@"SmallPlay"] forState:UIControlStateNormal];
    [self.player seekToTime:kCMTimeZero];
}

- (void)onLongPress:(UILongPressGestureRecognizer *)gesture{
    if(gesture.state == UIGestureRecognizerStateBegan){
        __weak typeof(self) wself = self;
        LGAlertView* alertView = [LGAlertView alertViewWithTitle:nil message:nil style:LGAlertViewStyleActionSheet buttonTitles:@[@"保存视频到相册"] cancelButtonTitle:@"取消" destructiveButtonTitle:nil];
        [alertView setActionHandler:^(LGAlertView *alertView, NSString *title, NSUInteger index){
            if(index == 0){
                [wself saveVideo];
            }
        }];
        [alertView setButtonsFont:[UIFont systemFontOfSize:18]];
        [alertView setCancelButtonFont:[UIFont systemFontOfSize:18]];
        [alertView setButtonsTitleColor:kCommonTeacherTintColor];
        [alertView setCancelButtonTitleColor:kCommonTeacherTintColor];
        [alertView setButtonsBackgroundColorHighlighted:[UIColor colorWithHexString:@"dddddd"]];
        [alertView setCancelButtonBackgroundColorHighlighted:[UIColor colorWithHexString:@"dddddd"]];
        [alertView showAnimated:YES completionHandler:nil];
    }
}

- (void)saveVideo{
    UISaveVideoAtPathToSavedPhotosAlbum(self.url.path, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
}

- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInf
{
    if(error){
        [ProgressHUD showHintText:@"视频保存失败"];
    }
    else{
        [ProgressHUD showHintText:@"视频保存成功"];
    }
}

- (void)dismiss{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
