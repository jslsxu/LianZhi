//
//  NotificationSimpleAudioRecordView.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/8/27.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "NotificationSimpleAudioRecordView.h"
#import "UIView+Animations.h"
#import "POP.h"
#import "NHAudioTool.h"

#define kRecordMaxTime              60
@interface NotificationSimpleAudioRecordView ()<NHAudioToolDelegate>
@property (nonatomic, strong)NHAudioTool*   audioTool;
@property (nonatomic, assign)NSInteger duration;
@property (nonatomic, copy)NSString *recordPath;
@property (nonatomic, assign)BOOL alert;
@end

@implementation NotificationSimpleAudioRecordView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, 50)];
        [_titleLabel setTextAlignment:NSTextAlignmentCenter];
        [_titleLabel setFont:[UIFont systemFontOfSize:16]];
        [_titleLabel setTextColor:[UIColor colorWithHexString:@"333333"]];
        [_titleLabel setText:@"按住说话"];
        [self addSubview:_titleLabel];
        
        _recordButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_recordButton setFrame:CGRectMake((self.width - 80) / 2, _titleLabel.bottom, 80, 80)];
        [_recordButton setImage:[UIImage imageNamed:@"press_to_record"] forState:UIControlStateNormal];
        [_recordButton setImage:[UIImage imageNamed:@"press_to_record"] forState:UIControlStateHighlighted];
        [_recordButton addTarget:self action:@selector(onRecordStart) forControlEvents:UIControlEventTouchDown];
        [_recordButton addTarget:self action:@selector(onRecordFinished) forControlEvents:UIControlEventTouchUpInside];
        [_recordButton addTarget:self action:@selector(onRecordCancel) forControlEvents:UIControlEventTouchUpOutside];
        [self addSubview:_recordButton];
    }
    return self;
}

- (NHAudioTool *)audioTool {
    if (!_audioTool) {
        _audioTool = [[NHAudioTool alloc] init];
        _audioTool.delegate = self;
    }
    return _audioTool;
}

- (void)onRecordStart{
    if(self.canRecord){
        [self.audioTool startToRecord];
        [UIView animationWithLayer:_recordButton.layer type:XMNAnimationTypeSmaller];
    }
    else{
        LGAlertView *alertView = [[LGAlertView alloc] initWithTitle:@"提示" message:@"录音已经存在，当前仅支持1条语音，请删除后重新添加" style:LGAlertViewStyleAlert buttonTitles:nil cancelButtonTitle:@"确定" destructiveButtonTitle:nil];
        [alertView setCancelButtonBackgroundColorHighlighted:[UIColor colorWithHexString:@"dddddd"]];
        [alertView showAnimated:YES completionHandler:nil];
    }
}

- (void)onRecordFinished{
    [self.audioTool stopRecord];
}

- (void)onRecordCancel{
    [self.audioTool stopRecord];
    
}

#pragma mark - NHAudioToolDelegate
- (void)audioToolDidStartToRecord{
    
}

- (void)audioTool:(NHAudioTool *)tool didUpdateCurrentRecordTime:(NSTimeInterval)time{
    self.duration = time;
     NSString *durationStr = nil;
    if(self.duration >= kRecordMaxTime){
        durationStr = [NSString stringWithFormat:@"剩余时间%zd秒",kRecordMaxTime - self.duration];
        [tool stopRecord];
    }
    else if(self.duration > kRecordMaxTime - 10){
        if(!self.alert){
            self.alert = YES;
            PlaySoundUtility *playSound = [[PlaySoundUtility alloc] initForPlayingVibrate];
            [playSound play];
        }
        durationStr = [NSString stringWithFormat:@"剩余时间%zd秒",kRecordMaxTime - self.duration];
    }
    else{
        durationStr = [NSString stringWithFormat:@"%02ld:%02ld",self.duration / 60, self.duration % 60];
    }
    [_titleLabel setText:durationStr];
}
- (void)audioTool:(NHAudioTool *)tool didEndToRecordWithRecordInfo:(NSDictionary *)info{
    NSLog(@"info is %@",info);
    self.alert = NO;
    NSString *amrFileKey = info[NHAudioToolAmrFilePathKey];// 相对路径
//    NSString *wavFileKey = info[NHAudioToolWAVFilePathKey];// 相对路径
    NSString *amrFile = [NHFileManager audioFileAbsolutePathForRelativePath:amrFileKey];// 绝对路径
//    NSString *wavFile = [NHFileManager audioFileAbsolutePathForRelativePath:wavFileKey];// 绝对路径
    
    //    NSNumber *duration = info[NHAudioToolFileDurationKey];      /时间
    
    self.recordPath = amrFile;
    AudioItem *audioItem = [[AudioItem alloc] init];
    [audioItem setTimeSpan:self.duration];
    [audioItem setAudioUrl:self.recordPath];
    if(self.recordCallback){
        self.recordCallback(audioItem);
    }
}

- (void)audioTool:(NHAudioTool *)tool didFailedOnRecord:(NSError *)error{
    self.alert = NO;
}
- (void)audioToolDidFailedBecauseTheDurtaionWasToShort{
    if(self.canRecord){
        [ProgressHUD showHintText:@"录音时间太短，请重新录制"];
        [_titleLabel setText:@"按住说话"];
        self.alert = NO;
    }
}

@end
