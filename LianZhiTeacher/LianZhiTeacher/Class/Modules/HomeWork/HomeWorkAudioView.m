//
//  HomeWorkAudioView.m
//  LianZhiTeacher
//
//  Created by jslsxu on 15/12/7.
//  Copyright © 2015年 jslsxu. All rights reserved.
//

#import "HomeWorkAudioView.h"

@interface HomeWorkAudioView ()<MLAudioRecorderDelegate>
@property (nonatomic, strong)MLAudioMeterObserver *meterObserver;
@property (nonatomic, strong)MLAudioRecorder*   recorder;
@property (nonatomic, strong)AmrRecordWriter*   amrWriter;
@property (nonatomic, strong)MLAudioPlayer*     player;
@property (nonatomic, strong)AmrPlayerReader*   amrReader;
@property (nonatomic, strong)NSTimer*           playTimer;
@property (nonatomic, assign)NSInteger          playTimeInterval;
@end

@implementation HomeWorkAudioView

- (void)dealloc
{
    //音谱检测关联着录音类，录音类要停止了。所以要设置其audioQueue为nil
    self.meterObserver.audioQueue = nil;
    [self.player stopPlaying];
    [self.recorder stopRecording];
}

- (void)dismiss
{
    if(self.playTimer)
    {
        [self.playTimer invalidate];
        self.playTimer = nil;
    }
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self.layer setBorderWidth:2];
        [self.layer setBorderColor:[UIColor colorWithHexString:@"ebebeb"].CGColor];
        
        _audioImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HomeWorkAudioPlaying3"]];
        [_audioImageView setOrigin:CGPointMake(25, (self.height - _audioImageView.height) / 2)];
        [self addSubview:_audioImageView];
        
        _timeSpanLabel = [[UILabel alloc] initWithFrame:CGRectMake(_audioImageView.right + 10, 0, 50, self.height)];
        [_timeSpanLabel setTextColor:[UIColor lightGrayColor]];
        [_timeSpanLabel setFont:[UIFont systemFontOfSize:13]];
        [self addSubview:_timeSpanLabel];
        
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteButton setFrame:CGRectMake(self.width - 30 - 50, (self.height - 50) / 2, 50, 50)];
        [_deleteButton addTarget:self action:@selector(onDeleteClicked) forControlEvents:UIControlEventTouchUpInside];
        [_deleteButton setImage:[UIImage imageNamed:@"HomeWorkAudioDelete"] forState:UIControlStateNormal];
        [self addSubview:_deleteButton];
        
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playButton setFrame:CGRectMake(_deleteButton.x - 15 - 50, (self.height - 50) / 2, 50, 50)];
        [_playButton setImage:[UIImage imageNamed:@"HomeWorkAudioPlay"] forState:UIControlStateNormal];
        [_playButton addTarget:self action:@selector(onPlayButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_playButton];
    }
    return self;
}

- (void)setTimeSpan:(NSInteger)timeSpan
{
    _timeSpan = timeSpan;
    [_timeSpanLabel setText:[Utility formatStringForTime:self.timeSpan]];
}

- (void)onDeleteClicked
{
    if(self.deleteCompletion)
        self.deleteCompletion();
}

- (void)onPlayButtonClicked
{
    if(!_isPlaying)
    {
        _isPlaying = YES;
        [_audioImageView setImage:[UIImage animatedImageNamed:@"HomeWorkAudioPlaying" duration:1.f]];
        [self playAudio];
    }
    else
    {
        [self stopAudio];
        [[MLAmrPlayer shareInstance] stopPlaying];
    }
}

- (void)playAudio
{
    NSString *filePath = [AudioRecordView tempFilePath];
    AmrRecordWriter *amrWriter = [[AmrRecordWriter alloc]init];
    amrWriter.filePath = filePath;
    amrWriter.maxSecondCount = 119;
    amrWriter.maxFileSize = 1024*256;
    self.amrWriter = amrWriter;
    
    MLAudioMeterObserver *meterObserver = [[MLAudioMeterObserver alloc]init];
    [meterObserver setRefreshInterval:0.1];
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
    
    MLAudioPlayer *player = [[MLAudioPlayer alloc]init];
    AmrPlayerReader *amrReader = [[AmrPlayerReader alloc]init];
    
    player.fileReaderDelegate = amrReader;
    player.receiveStoppedBlock = ^{
        [weakSelf stopAudio];
    };
    self.player = player;
    self.amrReader = amrReader;
    
    self.amrReader.filePath = self.amrWriter.filePath;
    [self.player startPlaying];
}

- (void)stopAudio
{
    _isPlaying = NO;
    [_audioImageView setImage:[UIImage imageNamed:@"HomeWorkAudioPlaying3"]];
}

@end
