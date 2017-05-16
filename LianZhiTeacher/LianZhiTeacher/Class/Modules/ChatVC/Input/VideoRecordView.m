//
//  VideoRecordView.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/7/21.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "VideoRecordView.h"
#import "SCRecorder.h"
#import "SCRecordSession.h"
#define kVideoMaxTime               8
@interface VideoRecordView ()<SCRecorderDelegate>
@property (nonatomic, strong)SCRecorder*    recorder;
@property (nonatomic, strong)SCRecordSession * recordSession;
@property (nonatomic, copy)void (^completion)(VideoItem *videoItem);
@property (nonatomic, strong)NSTimer*   pressTimer;
@property (nonatomic, strong)UIActivityIndicatorView *indicatorView;
@end

@implementation VideoRecordView

+ (void)showWithCompletion:(void (^)(VideoItem *))completion{
    VideoRecordView *recordView = [[VideoRecordView alloc] init];
    [recordView setCompletion:completion];
    [recordView show];
}

- (instancetype)initWithFrame:(CGRect)frame{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self = [super initWithFrame:window.bounds];
    if(self){
    
        _bgButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bgButton setFrame:self.bounds];
        [_bgButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [_bgButton setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
        [self addSubview:_bgButton];
        
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height / 2, self.width, self.height / 2)];
        [_contentView setBackgroundColor:[UIColor darkGrayColor]];
        [self addSubview:_contentView];
        
        _statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _contentView.top - 30, self.width, 30)];
        [_statusLabel setFont:[UIFont systemFontOfSize:16]];
        [_statusLabel setTextAlignment:NSTextAlignmentCenter];
        [_statusLabel setTextColor:[UIColor whiteColor]];
        [self addSubview:_statusLabel];
        
        _previewView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _contentView.width, _contentView.height - 60)];
        [_contentView addSubview:_previewView];
        
        _progressView = [[UIView alloc] initWithFrame:CGRectMake(0, _previewView.bottom, _contentView.width, 2)];
        [_progressView setBackgroundColor:kCommonTeacherTintColor];
        [_contentView addSubview:_progressView];
        
        _captureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_captureButton.layer setBorderColor:kCommonTeacherTintColor.CGColor];
        [_captureButton.layer setBorderWidth:2];
        [_captureButton.layer setCornerRadius:25];
        [_captureButton.layer setMasksToBounds:YES];
        [_captureButton setTitle:@"按住拍" forState:UIControlStateNormal];
        [_captureButton setTitleColor:kCommonTeacherTintColor forState:UIControlStateNormal];
        [_captureButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [_captureButton setFrame:CGRectMake((_contentView.width - 50) / 2, _previewView.height + (60 - 50) / 2, 50, 50)];
        [_captureButton addTarget:self action:@selector(startCapture) forControlEvents:UIControlEventTouchDown];
        [_captureButton addTarget:self action:@selector(captureFinished) forControlEvents:UIControlEventTouchUpInside];
        [_captureButton addTarget:self action:@selector(recordButtonDragExit) forControlEvents:UIControlEventTouchDragExit];
        [_captureButton addTarget:self action:@selector(recordButtonTouchUpOutside) forControlEvents:UIControlEventTouchUpOutside];
        [_contentView addSubview:_captureButton];
        
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [_indicatorView setHidesWhenStopped:YES];
        [_indicatorView setCenter:CGPointMake(_contentView.width / 2, _contentView.height / 2)];
        [_contentView addSubview:_indicatorView];
        
        [self configRecorder];
        [_recorder startRunning];
    }
    return self;
}

- (NSString *)tmpVideoPath{
    NSString *cachePath =  [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    return [cachePath stringByAppendingPathComponent:@"tmpVideo.mp4"];
}

- (void)configRecorder {
    _recorder = [SCRecorder recorder];
    _recorder.captureSessionPreset = [SCRecorderTools bestCaptureSessionPresetCompatibleWithAllDevices];
//    _recorder.maxRecordDuration = CMTimeMake(30 * kVideoMaxTime, 30);
    _recorder.delegate = self;
    _recorder.previewView = _previewView;
    _recorder.initializeSessionLazily = NO;
    [_recorder previewViewFrameChanged];
    NSError *error;
    if (![_recorder prepare:&error]) {
        NSLog(@"Prepare error: %@", error.localizedDescription);
    }
    if (_recorder.session == nil) {
        
        SCRecordSession *session = [SCRecordSession recordSession];
        session.fileType = AVFileTypeMPEG4;
        
        _recorder.session = session;
    }
    
}

- (void)refreshProgressViewLengthByTime:(CGFloat)duration{
    CGFloat scale = (kVideoMaxTime - duration) / kVideoMaxTime;
    [_progressView setTransform:CGAffineTransformMakeScale(scale, 1)];
}


- (void)startCapture{
    [_recorder record];
    [_statusLabel setText:@"向上滑动，取消发送"];
}

- (void)stopCapture{
    [_recorder stopRunning];
    _recorder.previewView = nil;
    
}

- (void)captureFinished{
    if(_recorder.isRecording){
        __weak typeof(self) wself = self;
        [_recorder pause:^{
            [wself saveCapture];
        }];
    }
}

- (void)recordButtonDragExit{
    [_statusLabel setText:@"松开手指，取消发送"];
}

- (void)recordButtonTouchUpOutside{
    if(_recorder.isRecording){
        __weak typeof(self) wself = self;
        [_recorder pause:^{
            [wself dismiss];
        }];
    }
    [_statusLabel setText:nil];
}

- (void)saveCapture {
    NSString *localVideoPath = [self tmpVideoPath];
    NSURL *url = [NSURL fileURLWithPath:localVideoPath];
    AVAsset *asset = _recorder.session.assetRepresentingSegments;
    [[NSFileManager defaultManager] removeItemAtURL:url error:nil];
    CGFloat duration = CMTimeGetSeconds(asset.duration);
    if(duration < 1){
        return;
    }
    CGSize videoSize = _previewView.bounds.size;
    AVAssetExportSession * exportSession = [AVAssetExportSession exportSessionWithAsset:asset presetName:AVAssetExportPresetMediumQuality];
    exportSession.outputFileType = AVFileTypeMPEG4;
    exportSession.shouldOptimizeForNetworkUse = YES;
    AVVideoComposition *composition = [self buildDefaultVideoCompositionWithAsset:asset targetSize:videoSize];
    exportSession.videoComposition = composition;
    exportSession.outputURL = url;
    [self.indicatorView startAnimating];
    @weakify(self);
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            @strongify(self);
            [self.indicatorView stopAnimating];
            if(self.completion){
                VideoItem *videoItem = [[VideoItem alloc] init];
                [videoItem setVideoUrl:localVideoPath];
                NSString *imagePath = [NHFileManager getTmpImagePath];
                UIImage *image = [UIImage coverImageForVideo:url];
                NSData *imageData = UIImageJPEGRepresentation(image, 0.8);
                [imageData writeToFile:imagePath atomically:YES];
                [videoItem setCoverUrl:imagePath];
                CMTime videoDuration = asset.duration;
                float videoDurationSeconds = CMTimeGetSeconds(videoDuration);
                [videoItem setVideoTime:videoDurationSeconds];
                [videoItem setCoverWidth:image.size.width];
                [videoItem setCoverHeight:image.size.height];
                self.completion(videoItem);
            }
            [self dismiss];
        });
        
    }];
}

- (AVMutableVideoComposition *)buildDefaultVideoCompositionWithAsset:(AVAsset *)asset targetSize:(CGSize)targetSize
{
    
    AVMutableVideoComposition *videoComposition = [AVMutableVideoComposition videoComposition];
    NSArray *trackArray = [asset tracksWithMediaType:AVMediaTypeVideo];
    if(trackArray.count > 0){
        AVAssetTrack *videoTrack = [trackArray objectAtIndex:0];
        
        videoComposition.frameDuration = CMTimeMake(1, 30);
        CGSize naturalSize = [videoTrack naturalSize];
        CGSize cropSize = CGSizeMake(naturalSize.width, naturalSize.width * targetSize.height / targetSize.width);
        CGAffineTransform transform = videoTrack.preferredTransform;
        CGFloat videoAngleInDegree  = atan2(transform.b, transform.a) * 180 / M_PI;
        if (videoAngleInDegree == 90 || videoAngleInDegree == -90) {
            CGFloat width = naturalSize.width;
            naturalSize.width = naturalSize.height;
            naturalSize.height = width;
        }
        videoComposition.renderSize = cropSize;
        transform = CGAffineTransformMakeTranslation(0, (cropSize.height - naturalSize.height) / 2);
        // Make a "pass through video track" video composition.
        AVMutableVideoCompositionInstruction *passThroughInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
        passThroughInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, asset.duration);
        
        AVMutableVideoCompositionLayerInstruction *passThroughLayer = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
        
        [passThroughLayer setTransform:transform atTime:kCMTimeZero];
        
        passThroughInstruction.layerInstructions = @[passThroughLayer];
        videoComposition.instructions = @[passThroughInstruction];
    }
    return videoComposition;
}


#pragma mark - SCRecorderDelegate
- (void)recorder:(SCRecorder *)recorder didAppendVideoSampleBufferInSession:(SCRecordSession *)recordSession {
    CGFloat duration = CMTimeGetSeconds(recordSession.duration);
    if(duration >= kVideoMaxTime){
        if(_recorder.isRecording){
            [_recorder pause:^{
                [self saveCapture];
            }];
        }
    }
    //update progressBar
    [self refreshProgressViewLengthByTime:duration];
}

- (void)recorder:(SCRecorder *__nonnull)recorder didCompleteSession:(SCRecordSession *__nonnull)session {
    [self saveCapture];
}

- (void)show{
    UIWindow *window= [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    _bgButton.alpha = 0.f;
    _contentView.y = self.height;
    [UIView animateWithDuration:0.3 animations:^{
        _bgButton.alpha = 1.f;
        _contentView.y = self.height - _contentView.height;
    }completion:^(BOOL finished) {
       
    }];
}

- (void)dismiss{
    if(self.pressTimer){
        [self.pressTimer invalidate];
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        [_bgButton setAlpha:0.f];
        [_contentView setY:self.height];
    } completion:^(BOOL finished) {
        [self stopCapture];
        [self removeFromSuperview];
    }];
}

@end

