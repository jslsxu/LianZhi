//
//  NotificationRecordView.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/6/30.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "NotificationAudioRecordView.h"
#import "UIView+Animations.h"
#import "POP.h"
#import "NHAudioTool.h"

#define kRecordMaxTime              60
@interface RecordView ()<NHAudioToolDelegate>
@property (nonatomic, strong)NHAudioTool*   audioTool;
@property (nonatomic, assign)NSInteger duration;
@property (nonatomic, copy)NSString *recordPath;
@property (nonatomic, assign)AudioRecordState recordState;
@property (nonatomic, assign)BOOL isRecording;
@end

@implementation RecordView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, 50)];
        [_titleLabel setTextAlignment:NSTextAlignmentCenter];
        [_titleLabel setFont:[UIFont systemFontOfSize:16]];
        [_titleLabel setTextColor:[UIColor colorWithHexString:@"333333"]];
        [_titleLabel setText:@"按住说话"];
        [self addSubview:_titleLabel];
        
        _pathImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"record_path"]];
        [_pathImageView setCenter:CGPointMake(self.width / 2, _titleLabel.bottom + 80 / 2)];
        [_pathImageView setHidden:YES];
        [self addSubview:_pathImageView];
        
        _playButton = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"record_play_normal"]];
        [_playButton setCenter:CGPointMake(_pathImageView.left, _pathImageView.y)];
        [_playButton setHidden:YES];
        [self addSubview:_playButton];
        
        _deleteButton = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"record_delete_normal"]];
        [_deleteButton setCenter:CGPointMake(_pathImageView.right, _pathImageView.y)];
        [_deleteButton setHidden:YES];
        [self addSubview:_deleteButton];
        
        _recordButton = [[UIImageView alloc] initWithFrame:CGRectMake((self.width - 80) / 2, _titleLabel.bottom, 80, 80)];
        [_recordButton setImage:[UIImage imageNamed:@"press_to_record"]];
        [self addSubview:_recordButton];
        
    }
    return self;
}
- (void)setRecordState:(AudioRecordState)recordState{
    if(_recordState != recordState){
        _recordState = recordState;
        if(_recordState == RecordStateNone){
            [_deleteButton setImage:[UIImage imageNamed:@"record_delete_normal"]];
            [_playButton setImage:[UIImage imageNamed:@"record_play_normal"]];
            [UIView animateWithDuration:0.3 animations:^{
                [_playButton setTransform:CGAffineTransformIdentity];
                [_deleteButton setTransform:CGAffineTransformIdentity];
            }];
        }
        else if(_recordState == RecordStateRecord){
            [_playButton setImage:[UIImage imageNamed:@"record_play_normal"]];
            [_deleteButton setImage:[UIImage imageNamed:@"record_delete_normal"]];
        }
        else if(_recordState == RecordStateEnterPlay){
            [_playButton setImage:[UIImage imageNamed:@"record_play_highlighted"]];
        }
        else{
            [_deleteButton setImage:[UIImage imageNamed:@"record_delete_highlighted"]];
        }
    }
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGPoint location = [[touches anyObject] locationInView:self];
    if(CGRectContainsPoint(_recordButton.frame, location)){
        self.isRecording = YES;
        self.recordState = RecordStateRecord;
        [UIView animationWithLayer:_recordButton.layer type:XMNAnimationTypeSmaller];
        [_pathImageView setHidden:NO];
        [_playButton setHidden:NO];
        [_deleteButton setHidden:NO];
        [self.audioTool startToRecord];
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGPoint location = [[touches anyObject] locationInView:self];
    if(!self.isRecording)
        return;
    CGFloat scale = 1.f;
    CGFloat distance = fabs(location.x - _recordButton.centerX);
    if(distance > _recordButton.width / 2){
        scale = (distance - _recordButton.width / 2) / (_pathImageView.width / 2 - _recordButton.width / 2) + 1;
        scale = MIN(2, scale);
    }
    if(location.x < _recordButton.centerX){
        _playButton.transform = CGAffineTransformMakeScale(scale, scale);
    }
    else{
        _deleteButton.transform = CGAffineTransformMakeScale(scale, scale);
    }
    if(CGRectContainsPoint(_playButton.frame, location)){
        self.recordState = RecordStateEnterPlay;
    }
    else if(CGRectContainsPoint(_deleteButton.frame, location)){
        self.recordState = RecordStateEnterDelete;
    }
    else
        self.recordState = RecordStateRecord;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.isRecording = NO;
    [self.audioTool stopRecord];
    if(self.recordState == RecordStateEnterPlay){
        if(self.playCallback){
            self.playCallback();
        }
    }
    else if(self.recordState == RecordStateEnterDelete){
        if(self.deleteCallback){
            self.deleteCallback();
        }
    }
    else if(self.recordState == RecordStateRecord){
        [self.audioTool stopRecord];
    }
    self.recordState = RecordStateNone;
}

- (NHAudioTool *)audioTool {
    if (!_audioTool) {
        _audioTool = [[NHAudioTool alloc] init];
        _audioTool.delegate = self;
    }
    return _audioTool;
}

#pragma mark - NHAudioToolDelegate
- (void)audioToolDidStartToRecord{
   
}

- (void)audioTool:(NHAudioTool *)tool didUpdateCurrentRecordTime:(NSTimeInterval)time{
    self.duration = time;
    NSString *durationStr = [NSString stringWithFormat:@"%02ld:%02ld",self.duration / 60, self.duration % 60];
    [_titleLabel setText:durationStr];
}
- (void)audioTool:(NHAudioTool *)tool didEndToRecordWithRecordInfo:(NSDictionary *)info{
    NSLog(@"info is %@",info);
    NSString *amrFileKey = info[NHAudioToolAmrFilePathKey];// 相对路径
//    NSString *wavFileKey = info[NHAudioToolWAVFilePathKey];// 相对路径
    NSString *amrFile = [NHFileManager audioFileAbsolutePathForRelativePath:amrFileKey];// 绝对路径
//    NSString *wavFile = [NHFileManager audioFileAbsolutePathForRelativePath:wavFileKey];// 绝对路径
    
//    NSNumber *duration = info[NHAudioToolFileDurationKey];      /时间

    self.recordPath = amrFile;
    if(self.recordFinished){
        self.recordFinished();
    }
}

- (void)audioTool:(NHAudioTool *)tool didFailedOnRecord:(NSError *)error{
    
}

@end

@interface ListenView ()<NHAudioToolDelegate>
@property (nonatomic, strong)NHAudioTool *audioTool;
@property (nonatomic, assign)NSInteger timeSpan;
@property (nonatomic, copy)NSString *recordPath;
@end

@implementation ListenView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, 30)];
        [_timeLabel setTextAlignment:NSTextAlignmentCenter];
        [_timeLabel setFont:[UIFont systemFontOfSize:13]];
        [_timeLabel setTextColor:[UIColor colorWithHexString:@"5d5d5d"]];
        [self addSubview:_timeLabel];
        
        _listenPlayButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_listenPlayButton setImage:[UIImage imageNamed:@"notification_audio_play"] forState:UIControlStateNormal];
        [_listenPlayButton setFrame:CGRectMake((self.width - 80) / 2, _timeLabel.bottom, 80, 80)];
        [_listenPlayButton addTarget:self action:@selector(onListenStart) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_listenPlayButton];
        
        UIView *sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - 35, self.width, kLineHeight)];
        [sepLine setBackgroundColor:kSepLineColor];
        [self addSubview:sepLine];
        
        UIView *vLine = [[UIView alloc] initWithFrame:CGRectMake(self.width / 2, self.height - 35, kLineHeight, 35)];
        [vLine setBackgroundColor:kSepLineColor];
        [self addSubview:vLine];
        
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelButton setFrame:CGRectMake(0, self.height - 35, self.width / 2, 35)];
        [cancelButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [cancelButton setTitleColor:kCommonTeacherTintColor forState:UIControlStateNormal];
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(onCancel) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancelButton];
        
        UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [sendButton setFrame:CGRectMake(self.width / 2, self.height - 35, self.width / 2, 35)];
        [sendButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [sendButton setTitleColor:kCommonTeacherTintColor forState:UIControlStateNormal];
        [sendButton setTitle:@"发送" forState:UIControlStateNormal];
        [sendButton addTarget:self action:@selector(onSend) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:sendButton];

    }
    return self;
}

- (void)setTimeSpan:(NSInteger)timeSpan{
    _timeSpan = timeSpan;
    [_timeLabel setText:[NSString stringWithFormat:@"%02zd:%02zd",_timeSpan / 60, _timeSpan % 60]];
}

- (void)onListenStart{
    self.audioTool = [[NHAudioTool alloc] init];
    [self.audioTool playAudioWithFilePath:self.recordPath];
}

- (void)onCancel{
    if(self.cancelCallBack){
        self.cancelCallBack();
    }
}

- (void)onSend{
    if(self.sendCallback){
        self.sendCallback();
    }
}

#pragma mark - NHAudioToolDelegate 
- (void)audioTool:(NHAudioTool *)tool startToPlayAudioFile:(NSString *)filePath{
    NSLog(@"start play %@",filePath);
}

- (void)audioTool:(NHAudioTool *)tool didSuccessPlayedFile:(NSString *)filePath{
    NSLog(@"success play %@",filePath);
}

- (void)audioTool:(NHAudioTool *)tool didFailedOnPlayAudioFile:(NSString *)filePath error:(NSError *)error{
    NSLog(@"fail play");
}

@end

@interface NotificationAudioRecordView ()
@property (nonatomic, copy)NSString*        recordPath;
@property (nonatomic, strong)RecordView*    recordView;
@property (nonatomic, strong)ListenView*    listenView;
@end

@implementation NotificationAudioRecordView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self showRecordView];
    }
    return self;
}

- (void)showRecordView{
    @weakify(self);
    self.recordView = [[RecordView alloc] initWithFrame:self.bounds];
    [self.recordView setPlayCallback:^{
        @strongify(self);
        [self showTestListenView];
    }];
    [self.recordView setDeleteCallback:^{
        @strongify(self);
        [self showRecordView];
    }];
    [self.recordView setRecordFinished:^{
        @strongify(self)
        if(self.sendCallback){
            self.sendCallback(self.recordView.recordPath, self.recordView.duration);
        }
        [self.recordView removeFromSuperview];
        [self showRecordView];
    }];
    [self addSubview:self.recordView];
    
    [self.listenView removeFromSuperview];
    self.listenView = nil;
}

- (void)showTestListenView{
    @weakify(self);
    self.listenView = [[ListenView alloc] initWithFrame:self.bounds];
    [self.listenView setTimeSpan:self.recordView.duration];
    [self.listenView setRecordPath:self.recordView.recordPath];
    [self.recordView.audioTool setDelegate:self.listenView];
    [self.listenView setCancelCallBack:^{
        @strongify(self);
        [self showRecordView];
    }];
    
    [self.listenView setSendCallback:^{
        @strongify(self);
        [self showRecordView];
        if(self.sendCallback){
            self.sendCallback(self.recordView.recordPath, self.listenView.timeSpan);
        }
    }];
    [self addSubview:self.listenView];
    
    [self.recordView removeFromSuperview];
    self.recordView = nil;
}

@end
