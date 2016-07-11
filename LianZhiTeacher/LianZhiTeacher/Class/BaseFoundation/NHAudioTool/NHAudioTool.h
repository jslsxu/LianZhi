//
//  NHAudioTool.h
//  NHInputView
//
//  Created by Wilson Yuan on 15/11/12.
//  Copyright © 2015年 Wilson-Yuan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, NHAudioFileType) {
    NHAudioFileTypeAmr,
    NHAudioFileTypeWAV,
};

typedef NS_ENUM(NSInteger, NHAudioRouteType) {
    NHAudioRouteType_Headerphone, // 听筒
    NHAudioRouteType_Speaker, // 扬声器
};


@class NHAudioTool;
@protocol NHAudioToolDelegate <NSObject>

@optional;
#pragma mark - AVAudioRecord
- (void)audioToolDidStartToRecord;

- (void)audioTool:(NHAudioTool *)tool didUpdateVoiceVolume:(NSInteger)volume;

- (void)audioTool:(NHAudioTool *)tool didUpdateCurrentRecordTime:(NSTimeInterval)time;

- (void)audioTool:(NHAudioTool *)tool didEndToRecordWithRecordInfo:(NSDictionary *)info;

- (void)audioTool:(NHAudioTool *)tool didFailedOnRecord:(NSError *)error;

- (void)audioToolDidFailedBecauseTheDurtaionWasToShort;


#pragma mark - AVAudioPlayer
- (void)audioTool:(NHAudioTool *)tool startToPlayAudioFile:(NSString *)filePath;

- (void)audioTool:(NHAudioTool *)tool didSuccessPlayedFile:(NSString *)filePath;

- (void)audioTool:(NHAudioTool *)tool didFailedOnPlayAudioFile:(NSString *)filePath error:(NSError *)error;

@end

static NSString const *NHAudioToolWAVFilePathKey = @"wavFilePath";
static NSString const *NHAudioToolWAVFileNameKey = @"wavFileName";
static NSString const *NHAudioToolWAVFileSizeKey = @"wavFileSize";

static NSString const *NHAudioToolFileDurationKey = @"duration";

static NSString const *NHAudioToolAmrFilePathKey = @"amrFilePath";
static NSString const *NHAudioToolAmrFileSizeKey = @"amrFileSize";
static NSString const *NHAudioToolAmrFileNameKey = @"amrFileName";

@interface NHAudioTool : NSObject

@property (weak, nonatomic) id<NHAudioToolDelegate> delegate;

@property (assign, nonatomic) NSTimeInterval minTimeInteverForRecord; //For recorder最小录音时间 default is 1

- (void)playAudioWithFilePath:(NSString *)filePath;
- (void)playAudioWithFilePath:(NSString *)filePath withOutputRouteType:(NHAudioRouteType)routeType;
- (BOOL)updateAudioSessionRouteType:(NHAudioRouteType)routeType;

- (void)stopToPlay;

- (void)startToRecord;

- (void)pauseToRecord;

- (void)stopRecord;

- (void)discardCurrentRecord;

- (NSDictionary *)audioFileInfoByfilePath:(NSString *)filePath fileType:(NHAudioFileType)type;
@end

