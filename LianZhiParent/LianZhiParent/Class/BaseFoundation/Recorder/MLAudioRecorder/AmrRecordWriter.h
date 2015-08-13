//
//  AmrRecordWriter.h
//  MLAudioRecorder
//
//  Created by molon on 5/12/14.
//  Copyright (c) 2014 molon. All rights reserved.
//
/**
 *  采样率必须为8000，然后缓冲区秒数必须为0.02的倍数。
 *
 */
#import <Foundation/Foundation.h>

#import "MLAudioRecorder.h"
@class AmrRecordWriter;
@protocol AmrRecordWriterDelegate <NSObject>
- (void)amrRecorderStartRecording:(AmrRecordWriter *)recorder;
- (void)amrRecorderEndRecording:(AmrRecordWriter *)recorder duration:(NSInteger)duration;

@end

@interface AmrRecordWriter : NSObject<FileWriterForMLAudioRecorder>

@property (nonatomic, copy) NSString *filePath;

@property (nonatomic, assign) unsigned long maxFileSize;
@property (nonatomic, assign) double maxSecondCount;
@property (nonatomic, weak)id<AmrRecordWriterDelegate> recordDelegate;
- (NSInteger)recordedDuration;
@end
