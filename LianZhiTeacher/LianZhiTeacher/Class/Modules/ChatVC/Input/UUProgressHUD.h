//
//  UUProgressHUD.h
//  1111
//
//  Created by shake on 14-8-6.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, RecordStatus){
    RecordStatusNormal = 0,
    RecordStatusDradOut,
    RecordStatusNearEnd,
    RecordStatusTooShort,
    RecordStatusDownCount,
};

@interface UUProgressHUD : UIView
{
    UIView*         _contentView;
    UIImageView*    _imageView;
    UILabel*        _titleLabel;
    UILabel*        _countDownLabel;
}
@property (nonatomic, copy)void (^recordCallBack)(NSString *recordPath, NSInteger time);

- (void)show;
- (void)dismiss;
- (void)startRecording;
- (void)endRecording;
- (void)cancelRecording;
- (void)remindDragExit;
- (void)remindDragEnter;
@end
