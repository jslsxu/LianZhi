//
//  NHAudioTool.m
//  NHInputView
//
//  Created by Wilson Yuan on 15/11/12.
//  Copyright © 2015年 Wilson-Yuan. All rights reserved.
//

#import "NHAudioTool.h"
//sys
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
//utils
#import "NHAudioConverter.h"
#import "NHAudioTool+Helper.h"
#import "NSString+UUID.h"
#import "NHFileManager.h"

@interface NHAudioTool ()<AVAudioPlayerDelegate>

@property (strong, nonatomic) AVAudioPlayer *audioPlayer;
@property (strong, nonatomic) AVAudioRecorder *recorder;
@property (strong, nonatomic) NSTimer *timer;

@property (copy, nonatomic) NSString *recordFileName;
@property (copy, nonatomic) NSString *recordFilePath;
@property (copy, nonatomic) NSString *playerFilePath;

@property (nonatomic) NSTimeInterval recordDuration;

@end

@implementation NHAudioTool
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.minTimeInteverForRecord = 1;
    }
    return self;
}
#pragma mark - AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    if (flag) {
        [self callDelegateDidSuccessedToPlayAudioFileIfCould];
    }
    else {
        [self callDelegateDidFailedToPlayAudioFileIfCouldWithError:nil];
    }
    
    [[AVAudioSession sharedInstance] setActive:NO
                                   withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation
                                         error:nil];
}


- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError * __nullable)error {
    [self callDelegateDidFailedToPlayAudioFileIfCouldWithError:error];
    
    [[AVAudioSession sharedInstance] setActive:NO
                                   withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation
                                         error:nil];
}



#pragma mark - Play

- (void)playAudioWithFilePath:(NSString *)filePath
{
    [self setCurrentAudioSessionActiveIfNecessary];
    
    [self stopToPlay];
    
    self.playerFilePath = filePath;
    
    self.audioPlayer = [self audioPlayerWithFilePath:filePath];
    
    [self.audioPlayer prepareToPlay];
    
    [self.audioPlayer play];
    
    [self callDelegateDidStartToPlayAudioFileIfCould];
}

- (void)playAudioWithFilePath:(NSString *)filePath withOutputRouteType:(NHAudioRouteType)routeType {
    [self setCurrentAudioSessionActiveWithRouteType:routeType];
    
    [self stopToPlay];
    
    self.playerFilePath = filePath;
    
    self.audioPlayer = [self audioPlayerWithFilePath:filePath];
    
    [self.audioPlayer prepareToPlay];
    
    [self.audioPlayer play];
    
    [self callDelegateDidStartToPlayAudioFileIfCould];
}

- (void)stopToPlay {
    
    if ([self.audioPlayer isPlaying]) {
        [self.audioPlayer stop];
    }
    self.audioPlayer = nil;
}

#pragma mark - Record
- (void)startToRecord {
    //停止播放
    [self stopToPlay];
    
    if ([self.recorder prepareToRecord]) {
        
        [self setCurrentAudioSessionActiveIfNecessary];
        
        if ([self.delegate respondsToSelector:@selector(audioToolDidStartToRecord)]) {
            [self.delegate audioToolDidStartToRecord];
        }
        
        [self.recorder record];
        [self startToUpdateMeters];
    }
    else if ([self.recorder isRecording]){
        [self.recorder record]; //resume
        [self startToUpdateMeters];
    }
    else {
        NSLog(@"###waring --- failure to resume the record");
    }
}

- (void)stopRecord {
    //判断
    if (![self isLargeThanMinTimeInteverForRecorder]) {
        [self callDelegateAudioToolDidFailedBecauseTheDurtaionWasToShort];
        [self discardCurrentRecord];
    }
    else {
        [self readyToStopRecord];
        [self convertWavFileToAmr];
    }
    //
    [self invalidateTimer];
}

- (BOOL)isLargeThanMinTimeInteverForRecorder {
    if (self.recorder.currentTime >= self.minTimeInteverForRecord) {
        return YES;
    }
    else {
        return NO;
    }
}

- (void)pauseToRecord {
    if ([self.recorder isRecording]) {
        [self.recorder pause];
    }
    [self invalidateTimer];
}

- (void)discardCurrentRecord {
    
    [self readyToStopRecord];
    //删除文件
    [self removeItemAtPath:self.recordFilePath];
}

- (void)readyToStopRecord {
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
    dispatch_after(delayTime, dispatch_get_global_queue(0, 0), ^{
        [[AVAudioSession sharedInstance] setActive:NO
                                       withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation
                                             error:nil];
    });
    
    self.recordDuration = self.recorder.currentTime;
    [self.recorder stop];
    [self resetRecorder];
    [self callDelegateToUpdateVoiceVolume:0];
    
}

- (void)invalidateTimer {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}
- (void)startToUpdateMeters {
    
    self.timer = [NSTimer timerWithTimeInterval:0.1 target:self selector:@selector(updateRecordMeters) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    [self.timer fire];
}


- (void)updateRecordMeters {
    
    [self.recorder updateMeters];
    
    float peakPower = [self.recorder averagePowerForChannel:0];
    double ALPHA = 0.05;
    double peakPowerForChannel = pow(10, (ALPHA * peakPower));
    CGFloat lowPassResults = MIN(MAX(0.f, peakPowerForChannel), 1.f);
    NSInteger volumn = 0;
    
    if (0<lowPassResults<=0.06) {
        volumn = 0;
    }else if (0.06<lowPassResults<=0.13) {
        volumn = 5;
    }else if (0.13<lowPassResults<=0.20) {
        volumn = 15;
    }else if (0.20<lowPassResults<=0.27) {
        volumn = 25;
    }else if (0.27<lowPassResults<=0.34) {
        volumn = 35;
    }else if (0.34<lowPassResults<=0.41) {
        volumn = 45;
    }else if (0.41<lowPassResults<=0.48) {
        volumn = 50;
    }else if (0.48<lowPassResults<=0.55) {
        volumn = 55;
    }else if (0.55<lowPassResults<=0.62) {
        volumn = 58;
    }else if (0.62<lowPassResults<=0.69) {
        volumn = 62;
    }else if (0.69<lowPassResults<=0.76) {
        volumn = 68;
    }else if (0.76<lowPassResults<=0.83) {
        volumn = 70;
    }else if (0.83<lowPassResults<=0.9) {
        volumn = 80;
    }else {
        volumn = 90;
    }
    
    [self callDelegateToUpdateVoiceVolume:volumn];
    [self callDelegateToUpdateCurrentRecrodTime:self.recorder.currentTime];
}


#pragma mark - File
- (void)convertWavFileToAmr {
    //转换后的path
    NSString *amrPath = [self pathByFileName:self.recordFileName ofType:NHFIleManagerAmrExtensionKey];
    
    if ([NHAudioConverter convertWavToAmrWithWavPath:self.recordFilePath amrSavePath:amrPath]) {
        //Success
        
//        NSTimeInterval duration = [self ]
        //获得信息
        NSDictionary *amrInfo = [self audioFileInfoByfilePath:amrPath fileType:NHAudioFileTypeAmr];
        NSMutableDictionary *fileInfo = [NSMutableDictionary dictionaryWithDictionary:amrInfo];

        [fileInfo setObject:[NHFileManager audioFileRelativePathForAbsolutePath:amrPath] forKey:NHAudioToolAmrFilePathKey];
        [fileInfo setObject:@(@(self.recordDuration).integerValue) forKey:NHAudioToolFileDurationKey];
        [fileInfo setObject:[NHFileManager audioFileRelativePathForAbsolutePath:self.recordFilePath] forKey:NHAudioToolWAVFilePathKey];
        [fileInfo setObject:[self.recordFileName stringByAppendingPathExtension:NHFIleManagerWavExtensionKey] forKey:NHAudioToolWAVFileNameKey];
        
        [self callDelegateDidEndRecord:fileInfo];
        
    }
    else {
        [self callDelegateDidFailedToRecord];
        NSLog(@"#waring------NHAudioConverter convert wav to amr was filed. file path: %@", self.recordFilePath);
    }
}

- (void)resetRecorder {
    self.recorder = nil;
}
#pragma mark - Call method
- (void)callDelegateDidStartToPlayAudioFileIfCould {
    if ([self.delegate respondsToSelector:@selector(audioTool:startToPlayAudioFile:)]) {
        [self.delegate audioTool:self startToPlayAudioFile:self.playerFilePath];
    }
}
- (void)callDelegateDidSuccessedToPlayAudioFileIfCould {
    if ([self.delegate respondsToSelector:@selector(audioTool:didSuccessPlayedFile:)]) {
        [self.delegate audioTool:self didSuccessPlayedFile:self.playerFilePath];
    }
}
- (void)callDelegateDidFailedToPlayAudioFileIfCouldWithError:(NSError *)error {
    if ([self.delegate respondsToSelector:@selector(audioTool:didFailedOnPlayAudioFile:error:)]) {
        [self.delegate audioTool:self didFailedOnPlayAudioFile:self.playerFilePath error:error];
    }
}
- (void)callDelegateAudioToolDidFailedBecauseTheDurtaionWasToShort {
    if ([self.delegate respondsToSelector:@selector(audioToolDidFailedBecauseTheDurtaionWasToShort)]) {
        [self.delegate audioToolDidFailedBecauseTheDurtaionWasToShort];
    }
}


- (void)callDelegateDidEndRecord:(NSDictionary *)fileInfo {
    if ([self.delegate respondsToSelector:@selector(audioTool:didEndToRecordWithRecordInfo:)]) {
        [self.delegate audioTool:self didEndToRecordWithRecordInfo:fileInfo];
    }
}

- (void)callDelegateDidFailedToRecord {
    if ([self.delegate respondsToSelector:@selector(audioTool:didFailedOnRecord:)]) {
        [self.delegate audioTool:self didFailedOnRecord:nil];
    }
}


- (void)callDelegateToUpdateVoiceVolume:(CGFloat)volumn {
    if ([self.delegate respondsToSelector:@selector(audioTool:didUpdateVoiceVolume:)]) {
        [self.delegate audioTool:self didUpdateVoiceVolume:volumn];
    }
}

- (void)callDelegateToUpdateCurrentRecrodTime:(NSTimeInterval)time {
    if ([self.delegate respondsToSelector:@selector(audioTool:didUpdateCurrentRecordTime:)]) {
        [self.delegate audioTool:self didUpdateCurrentRecordTime:time];
    }
}

- (NSDictionary *)audioFileInfoByfilePath:(NSString *)filePath fileType:(NHAudioFileType)type {
    
    NSUInteger fileSize = [self fileSizeAtPath:filePath] / 1024;
    NSString *fileName = filePath.lastPathComponent;
    
    CGFloat duration;
    //Amr得不到duration
    if ([fileName rangeOfString:@"wav"].length > 0) {
        AVAudioPlayer *player = [self audioPlayerWithFilePath:filePath];
        duration = @(player.duration).floatValue;
    }
    else {
        duration = 0;
    }
    if (duration <= 0) {
        duration = 0;
    }
    if (type == NHAudioFileTypeAmr) {
        return @{NHAudioToolAmrFileSizeKey : @(fileSize),
                 NHAudioToolAmrFileNameKey: fileName,
                 NHAudioToolFileDurationKey : @(duration)};
    }
    else if (type == NHAudioFileTypeWAV){
        return @{NHAudioToolWAVFileSizeKey : @(fileSize),
                 NHAudioToolWAVFileNameKey : fileName,
                 NHAudioToolFileDurationKey : @(duration)};

    }
    else {
        return nil;
    }
}

- (void)setCurrentAudioSessionActiveIfNecessary {
    
    NSError *error;
    BOOL suc = NO;
    AVAudioSession *session = [AVAudioSession sharedInstance];
    suc = [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
    [self printErrorInfomation:error];
    
    if (suc) {
        [[AVAudioSession sharedInstance] setActive:YES error:&error];
        [self printErrorInfomation:error];
    }
    
}

- (void)setCurrentAudioSessionActiveWithRouteType:(NHAudioRouteType)routeType {
    NSError *error;
    BOOL suc = NO;
    AVAudioSession *session = [AVAudioSession sharedInstance];
    suc = [session setCategory:AVAudioSessionCategoryPlayAndRecord
                          error:&error];
    [self printErrorInfomation:error];
    
    if (suc) {
        AVAudioSessionPortOverride portOverride = AVAudioSessionPortOverrideNone;
        if (routeType == NHAudioRouteType_Speaker) {
            portOverride = AVAudioSessionPortOverrideSpeaker;
        }
        
        suc = [session overrideOutputAudioPort:portOverride
                                         error:&error];
        [self printErrorInfomation:error];
    }
    
    if (suc) {
        [[AVAudioSession sharedInstance] setActive:YES
                                       withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation
                                             error:&error];
        [self printErrorInfomation:error];
    }
}

- (BOOL)updateAudioSessionRouteType:(NHAudioRouteType)routeType {
    AVAudioSession *session = [AVAudioSession sharedInstance];
    AVAudioSessionPortOverride portOverride = AVAudioSessionPortOverrideNone;
    if (routeType == NHAudioRouteType_Headerphone) {
        portOverride = AVAudioSessionPortOverrideNone;
    }
    else {
        portOverride = AVAudioSessionPortOverrideSpeaker;
    }
    
    BOOL suc = NO;
    NSError *error = nil;
    suc = [session overrideOutputAudioPort:portOverride
                                     error:&error];
    
    return suc;
}

- (void)printErrorInfomation:(NSError *)error {
    if (error) {
        NSLog(@"NHAudioTool Error: %@", error.description);
        error = nil;
    }
}

#pragma mark - Getter
- (AVAudioRecorder *)recorder {
    if (!_recorder) {
        self.recordFileName = [NSString uuidStr];
        self.recordFilePath = [self pathByFileName:self.recordFileName ofType:NHFIleManagerWavExtensionKey];
        NSError *error;
        _recorder = [[AVAudioRecorder alloc] initWithURL:[NSURL fileURLWithPath:self.recordFilePath] settings:[NHAudioConverter audioRecorderSettingDict] error:&error];
        _recorder.meteringEnabled = YES;
    }
    return _recorder;
}

- (AVAudioPlayer *)audioPlayerWithFilePath:(NSString *)filePath {
    if (!filePath) {
        return nil;
    }
    
    //拼接路径
    filePath = [NHFileManager audioFileAbsolutePathForRelativePath:filePath];
    if (!_audioPlayer) {
        
        NSError *error;
        _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:filePath] error:&error];
        _audioPlayer.delegate = self;
        if (error) {
            NSLog(@"playerWithFilePath error: %@", error.description);
        }
    }
    return _audioPlayer;
}
@end
