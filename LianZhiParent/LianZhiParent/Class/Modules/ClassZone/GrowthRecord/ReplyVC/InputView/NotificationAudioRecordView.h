//
//  NotificationRecordView.h
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/6/30.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, AudioRecordState){
    RecordStateNone,
    RecordStateRecord,
    RecordStateEnterPlay,
    RecordStateEnterDelete,
};

@interface RecordView : UIView{
    UIImageView*    _pathImageView;
    UILabel*    _titleLabel;
    UIImageView*    _recordButton;
    UIImageView*    _playButton;
    UIImageView*    _deleteButton;
}
@property (nonatomic, copy)void (^playCallback)();
@property (nonatomic, copy)void (^deleteCallback)();
@property (nonatomic, copy)void (^recordFinished)();
@end

@interface ListenView : UIView{
    UILabel*        _timeLabel;
    UIButton*        _listenPlayButton;
}
@property (nonatomic, copy)void (^cancelCallBack)();
@property (nonatomic, copy)void (^sendCallback)();
@end

@interface NotificationAudioRecordView : UIView{
    
}
@property (nonatomic, copy)void (^cancelCallback)();
@property (nonatomic, copy)void (^sendCallback)(NSString *filePath, NSInteger duration);
@end
