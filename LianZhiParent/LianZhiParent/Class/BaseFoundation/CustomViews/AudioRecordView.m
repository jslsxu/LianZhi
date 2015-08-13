//
//  AudioRecordView.m
//  LianZhiParent
//
//  Created by jslsxu on 15/1/6.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "AudioRecordView.h"

@interface AudioRecordView()
@property (nonatomic, strong)MLAudioMeterObserver *meterObserver;
@property (nonatomic, strong)MLAudioRecorder*   recorder;
@property (nonatomic, strong)AmrRecordWriter*   amrWriter;
@property (nonatomic, strong)MLAudioPlayer*     player;
@property (nonatomic, strong)AmrPlayerReader*   amrReader;
@property (nonatomic, assign)NSInteger          duration;
@end

@implementation AudioRecordView

- (void)dealloc
{
    //音谱检测关联着录音类，录音类要停止了。所以要设置其audioQueue为nil
    self.meterObserver.audioQueue = nil;
    [self.player stopPlaying];
    [self.recorder stopRecording];
}

- (NSData *)tmpAmrData
{
    return [NSData dataWithContentsOfFile:[[self class] tempFilePath]];
}

- (NSInteger)tmpAmrDuration
{
    return self.duration;
}

+ (NSString *)tempFilePath
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [path stringByAppendingPathComponent:@"record.amr"];
    return filePath;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteButton setFrame:CGRectMake(10, 10, 40, 40)];
        [_deleteButton addTarget:self action:@selector(onDeleteAudioClicked) forControlEvents:UIControlEventTouchUpInside];
        [_deleteButton setImage:[UIImage imageNamed:MJRefreshSrcName(@"MessageTrash.png")] forState:UIControlStateNormal];
        [_deleteButton setHidden:YES];
        [self addSubview:_deleteButton];
        
        _audioIndicator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MicrophoneGray.png"]];
        [_audioIndicator setCenter:CGPointMake(80, self.height / 2)];
        [self addSubview:_audioIndicator];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        [_timeLabel setBackgroundColor:[UIColor clearColor]];
        [_timeLabel setTextAlignment:NSTextAlignmentCenter];
        [_timeLabel setFont:[UIFont boldSystemFontOfSize:32]];
        [_timeLabel setText:@"0:00"];
        [_timeLabel setTextColor:[UIColor colorWithRed:83 / 255.0 green:83 / 255.0 blue:83 / 255.0 alpha:1.f]];
        [_timeLabel setFrame:CGRectMake(self.width / 2, _audioIndicator.y, 110, _audioIndicator.height / 2)];
        [self addSubview:_timeLabel];
        
        _recordButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_recordButton setFrame:CGRectMake(self.width / 2, _timeLabel.bottom, 110, _audioIndicator.height  / 2)];
        [_recordButton setImage:[UIImage imageNamed:@"StartRecord.png"] forState:UIControlStateNormal];
        [_recordButton addTarget:self action:@selector(onRecordButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_recordButton];
        
        NSString *filePath = [[self class] tempFilePath];
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
        AmrRecordWriter *amrWriter = [[AmrRecordWriter alloc]init];
        amrWriter.filePath = filePath;
        amrWriter.maxSecondCount = 119;
        amrWriter.maxFileSize = 1024*256;
        self.amrWriter = amrWriter;
        
        MLAudioMeterObserver *meterObserver = [[MLAudioMeterObserver alloc]init];
        [meterObserver setRefreshInterval:0.1];
        meterObserver.actionBlock = ^(NSArray *levelMeterStates,MLAudioMeterObserver *meterObserver){
            NSInteger index = [MLAudioMeterObserver volumeForLevelMeterStates:levelMeterStates] * 13 + 1;
            NSString *imageStr = [NSString stringWithFormat:@"Recording%ld.png",(long)index];
            [_audioIndicator setImage:[UIImage imageNamed:(imageStr)]];
        };
//        meterObserver.errorBlock = ^(NSError *error,MLAudioMeterObserver *meterObserver){
//            [[[UIAlertView alloc]initWithTitle:@"错误" message:error.userInfo[NSLocalizedDescriptionKey] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"知道了", nil]show];
//        };
        self.meterObserver = meterObserver;
        
        MLAudioRecorder *recorder = [[MLAudioRecorder alloc]init];
        [recorder setDelegate:self];
        __weak __typeof(self)weakSelf = self;
        recorder.receiveStoppedBlock = ^{
            [weakSelf setRecordType:RecordTypePlay];
            weakSelf.meterObserver.audioQueue = nil;
            if([self.delegate respondsToSelector:@selector(audioRecordViewDidFinishedRecord:)])
                [self.delegate audioRecordViewDidFinishedRecord:self];
        };
        recorder.receiveErrorBlock = ^(NSError *error){
            [weakSelf setRecordType:RecordTypePrepareToRecord];
            weakSelf.meterObserver.audioQueue = nil;
            [[[UIAlertView alloc]initWithTitle:@"错误" message:error.userInfo[NSLocalizedDescriptionKey] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"知道了", nil]show];
        };
        
        //amr
        recorder.bufferDurationSeconds = 0.5;
        recorder.fileWriterDelegate = self.amrWriter;
        self.recorder = recorder;
        
        MLAudioPlayer *player = [[MLAudioPlayer alloc]init];
        AmrPlayerReader *amrReader = [[AmrPlayerReader alloc]init];
        
        player.fileReaderDelegate = amrReader;
        player.receiveErrorBlock = ^(NSError *error){
            [weakSelf setRecordType:RecordTypePlay];
            [[[UIAlertView alloc]initWithTitle:@"错误" message:error.userInfo[NSLocalizedDescriptionKey] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"知道了", nil]show];
        };
        player.receiveStoppedBlock = ^{
            [weakSelf setRecordType:RecordTypePlay];
        };
        self.player = player;
        self.amrReader = amrReader;

    }
    return self;
}

- (void)onRecordButtonClicked
{
    if(self.recordType == RecordTypePrepareToRecord)
    {
        if([self.delegate respondsToSelector:@selector(audioRecordViewDidStartRecord:)])
            [self.delegate audioRecordViewDidStartRecord:self];
        [[MLAmrPlayer shareInstance] stopPlaying];
        self.duration = 0;
        [self.recorder startRecording];
        [self setRecordType:RecordTypeStopRecord];
        self.meterObserver.audioQueue = self.recorder->_audioQueue;
    }
    else if(self.recordType == RecordTypeStopRecord)
    {
        if([self.delegate respondsToSelector:@selector(audioRecordViewDidFinishedRecord:)])
            [self.delegate audioRecordViewDidFinishedRecord:self];
        [self.recorder stopRecording];
        [self setRecordType:RecordTypePlay];
    }
    else if(self.recordType == RecordTypePlay)
    {
        self.amrReader.filePath = self.amrWriter.filePath;
        [self.player startPlaying];
        [self setRecordType:RecordTypeEndPlay];
    }
    else
    {
        [self.player stopPlaying];
        [self setRecordType:RecordTypePlay];
    }
}

- (void)setRecordType:(RecordType)recordType
{
    _recordType = recordType;
    NSString *imageStr = nil;
    NSString *iphoneStr = @"MicrophoneGreen.png";
    [UIApplication sharedApplication].idleTimerDisabled=NO;
    if(self.recordType == RecordTypePrepareToRecord)
    {
        imageStr = @"StartRecord.png";
        iphoneStr = @"MicrophoneGray.png";
    }
    else if (self.recordType == RecordTypeStopRecord)
    {
        [UIApplication sharedApplication].idleTimerDisabled=YES;
        imageStr = @"StopRecord.png";
    }
    else if(self.recordType == RecordTypePlay)
        imageStr = @"StartPlay.png";
    else
        imageStr = @"StopPlay.png";
    [_deleteButton setHidden:self.recordType == RecordTypeStopRecord || self.recordType == RecordTypePrepareToRecord];
    [_timeLabel setTextColor:[UIColor colorWithRed:83 / 255.0 green:83 / 255.0 blue:83 / 255.0 alpha:1.f]];
    [_recordButton setImage:[UIImage imageNamed:imageStr] forState:UIControlStateNormal];
    [_audioIndicator setImage:[UIImage imageNamed:iphoneStr]];
}

- (void)onDeleteAudioClicked
{
    TNButtonItem *cancelItem = [TNButtonItem itemWithTitle:@"取消" action:nil];
    TNButtonItem *confirmItem = [TNButtonItem itemWithTitle:@"确定" action:^{
        [self.recorder stopRecording];
        [self.player stopPlaying];
        [[NSFileManager defaultManager] removeItemAtPath:self.amrWriter.filePath error:nil];
        [_timeLabel setText:@"0:00"];
        [self setRecordType:RecordTypePrepareToRecord];
    }];
    TNAlertView *alertView = [[TNAlertView alloc] initWithTitle:@"是否删除此录音信息" buttonItems:@[cancelItem,confirmItem]];
    [alertView show];
}

#pragma mark - MLAudioRecordDelegate
- (void)audioRecorder:(MLAudioRecorder *)recorder recordTime:(NSInteger)timeInterval
{
//    self.duration = timeInterval;
    self.duration = self.amrWriter.recordedDuration;
    static BOOL changed = NO;
    if(self.duration > 110 && self.duration <= 119)
    {
        changed = !changed;
        [_timeLabel setTextColor:changed ? [UIColor colorWithRed:192 / 255.0 green:118 / 255.0 blue:119 / 255.0 alpha:1.f] : [UIColor colorWithRed:83 / 255.0 green:83 / 255.0 blue:83 / 255.0 alpha:1.f]];
//        [_audioIndicator setImage:[UIImage imageNamed:MJRefreshSrcName(@"MicrophoneRed.png")]];
    }
    else
        changed = NO;
    [_timeLabel setText:[NSString stringWithFormat:@"%ld:%02ld",(long)self.duration / 60, (long)self.duration % 60]];
}
@end
