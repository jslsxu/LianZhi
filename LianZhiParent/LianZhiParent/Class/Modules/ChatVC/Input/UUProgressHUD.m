//
//  UUProgressHUD.m
//  1111
//
//  Created by shake on 14-8-6.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//

#import "UUProgressHUD.h"

#define kContentViewWidth           160
#define kContentViewHeight          160

#define kMaxRecordTime              119

@interface UUProgressHUD ()<MLAudioRecorderDelegate>
@property (nonatomic, copy)NSString *recordPath;
@property (nonatomic, assign)RecordStatus recordStatus;
@property (nonatomic, strong)NSTimer* timer;
@property (nonatomic, assign)NSInteger playTime;
@property (nonatomic, strong)MLAudioMeterObserver *meterObserver;
@property (nonatomic, strong)MLAudioRecorder*   recorder;
@property (nonatomic, strong)AmrRecordWriter*   amrWriter;
@end

@implementation UUProgressHUD

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if(self)
    {
        [self setBackgroundColor:[UIColor clearColor]];
        
        _contentView = [[UIView alloc] initWithFrame:CGRectMake((self.width - kContentViewWidth) / 2, (self.height - kContentViewHeight) / 2, kContentViewWidth, kContentViewHeight)];
        [_contentView setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.4]];
        [_contentView.layer setCornerRadius:10];
        [_contentView.layer setMasksToBounds:YES];
        [self addSubview:_contentView];
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 20, _contentView.width - 30 * 2, _contentView.height - 30 * 2)];
        [_imageView setContentMode:UIViewContentModeCenter];
        [_contentView addSubview:_imageView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _imageView.bottom, _contentView.width, 40)];
        [_titleLabel setTextAlignment:NSTextAlignmentCenter];
        [_titleLabel setFont:[UIFont systemFontOfSize:16]];
        [_titleLabel setTextColor:[UIColor whiteColor]];
        [_contentView addSubview:_titleLabel];
        
        _countDownLabel = [[UILabel alloc] initWithFrame:_contentView.bounds];
        [_countDownLabel setTextAlignment:NSTextAlignmentCenter];
        [_countDownLabel setFont:[UIFont boldSystemFontOfSize:100]];
        [_countDownLabel setTextColor:[UIColor whiteColor]];
        [_countDownLabel setHidden:YES];
        [_contentView addSubview:_countDownLabel];
        
        [self setupRecorder];
    }
    return self;
}

- (void)performCallback
{
    if(self.recordCallBack)
        self.recordCallBack(self.recordPath ,self.playTime);
    self.recordCallBack = nil;
}

- (void)setupRecorder
{
    //    [[MLAmrPlayer shareInstance] stopPlaying];
    self.recordPath = [NHFileManager getTmpRecordPath];
    [[NSFileManager defaultManager] removeItemAtPath:self.recordPath  error:nil];
    AmrRecordWriter *amrWriter = [[AmrRecordWriter alloc]init];
    amrWriter.filePath = self.recordPath ;
    amrWriter.maxSecondCount = kMaxRecordTime;
    amrWriter.maxFileSize = 1024*256;
    self.amrWriter = amrWriter;
    
    MLAudioMeterObserver *meterObserver = [[MLAudioMeterObserver alloc]init];
    [meterObserver setRefreshInterval:0.1];
    meterObserver.actionBlock = ^(NSArray *levelMeterStates,MLAudioMeterObserver *meterObserver){
        NSInteger index = [MLAudioMeterObserver volumeForLevelMeterStates:levelMeterStates] * 10 + 1;
        NSString *imageStr = [NSString stringWithFormat:@"ChatRecord%ld",(long)index];
        if(self.recordStatus == RecordStatusNormal)
            [_imageView setImage:[UIImage imageNamed:(imageStr)]];
    };
    
    self.meterObserver = meterObserver;
    
    MLAudioRecorder *recorder = [[MLAudioRecorder alloc]init];
    [recorder setDelegate:self];
    __weak __typeof(self)weakSelf = self;
    recorder.receiveStoppedBlock = ^{
        weakSelf.meterObserver.audioQueue = nil;
        
    };
    recorder.receiveErrorBlock = ^(NSError *error){
        weakSelf.meterObserver.audioQueue = nil;
    };
    
    //amr
    recorder.bufferDurationSeconds = 0.5;
    recorder.fileWriterDelegate = self.amrWriter;
    self.recorder = recorder;
    
}

- (void)setRecordStatus:(RecordStatus)recordStatus
{
    _recordStatus = recordStatus;
    NSString *imageStr = nil;
    NSString *title = nil;
    if(_recordStatus == RecordStatusNormal)
    {
        imageStr = @"ChatRecord1";
        NSInteger timeLeft = kMaxRecordTime - self.playTime;
        if(timeLeft >= 10){
            title = @"手指上滑，取消发送";
        }
        else{
            title = [NSString stringWithFormat:@"还可以说%zd秒",timeLeft];
        }
    }
    else if(_recordStatus == RecordStatusDradOut)
    {
        imageStr = @"ChatRecordCancel";
        title = @"松开手指，取消发送";
    }
    else if(_recordStatus == RecordStatusNearEnd)
    {
        imageStr = @"ChatRecord1";
        title = [NSString stringWithFormat:@"还可以说%ld秒",(long)kMaxRecordTime - self.playTime];
    }
    else
    {
        imageStr = @"ChatRecordTooShort";
        title = @"录音时间太短";
    }
    [_imageView setImage:[UIImage imageNamed:imageStr]];
    [_titleLabel setText:title];
}

- (void)countVoiceTime
{
    self.playTime ++;
    NSInteger timeLeft = kMaxRecordTime - self.playTime;
    if(timeLeft < 10 && self.recordStatus == RecordStatusNormal){
        NSString *title = [NSString stringWithFormat:@"还可以说%zd秒",timeLeft];
        [_titleLabel setText:title];
    }
//    NSInteger timeLeft = kMaxRecordTime - self.playTime;
//    if(timeLeft < 10){
//        [_imageView setHidden:YES];
//        [_titleLabel setHidden:YES];
//        [_countDownLabel setHidden:NO];
//        [_countDownLabel setText:kStringFromValue(timeLeft)];
//    }
//    else{
//        [_imageView setHidden:NO];
//        [_titleLabel setHidden:NO];
//        [_countDownLabel setHidden:YES];
//    }

    if (self.playTime >= kMaxRecordTime)
        [self endRecording];
}

- (void)startRecording
{
    self.playTime = 0;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countVoiceTime) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    [self.recorder startRecording];
    self.meterObserver.audioQueue = self.recorder->_audioQueue;
}

- (void)endRecording
{
    if (self.timer)
    {
        [self.recorder stopRecording];
        [self.timer invalidate];
        self.timer = nil;
    }
    if(self.playTime < 2)
        self.recordStatus = RecordStatusTooShort;
    else
        [self performCallback];
    [self dismiss];
}

- (void)cancelRecording
{
    if (self.timer)
    {
        [self.recorder stopRecording];
        [self.timer invalidate];
        self.timer = nil;
    }
    [self dismiss];
}

- (void)remindDragEnter
{
    self.recordStatus = RecordStatusNormal;
}

- (void)remindDragExit
{
    self.recordStatus = RecordStatusDradOut;
}

- (void)show
{
    self.alpha = 1.f;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    self.recordStatus = RecordStatusNormal;
}

- (void)dismiss
{
    [self.timer invalidate];
    self.timer = nil;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.f;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)audioRecorder:(MLAudioRecorder *)recorder recordTime:(NSInteger)timeInterval
{
    
}

@end
