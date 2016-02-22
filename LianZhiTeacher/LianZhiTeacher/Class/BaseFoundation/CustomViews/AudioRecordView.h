//
//  AudioRecordView.h
//  LianZhiParent
//
//  Created by jslsxu on 15/1/6.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLAudioRecorder.h"
#import "AmrRecordWriter.h"
#import "MLAudioMeterObserver.h"
@class AudioRecordView;
@protocol AudioRecordViewDelegate <NSObject>
@optional
- (void)audioRecordViewDidStartRecord:(AudioRecordView *)recordView;
- (void)audioRecordViewDidFinishedRecord:(AudioRecordView *)recordView ;
- (void)audioRecordViewDidCancl:(AudioRecordView *)recordView;

@end

typedef CF_ENUM(NSInteger, RecordType){
    RecordTypePrepareToRecord = 0,
    RecordTypeStopRecord,
    RecordTypePlay,
    RecordTypeEndPlay,
};

@interface AudioRecordView : UIView<MLAudioRecorderDelegate>
{
    UIButton*           _deleteButton;
    UIImageView*        _audioIndicator;
    UILabel*            _timeLabel;
    UIButton*           _recordButton;
}
@property (nonatomic, assign)RecordType recordType;
@property (nonatomic, weak)id<AudioRecordViewDelegate> delegate;
@property (nonatomic, assign)NSInteger          duration;
- (void)stopRecord;
+ (NSString *)tempFilePath;
- (NSData *)tmpAmrData;
- (void)setTmpAmrData:(NSData *)amrData;
- (NSInteger)tmpAmrDuration;
- (void)dismiss;
@end
