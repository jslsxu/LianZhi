//
//  NotificationInputView.h
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/6/30.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NotificationAudioRecordView.h"
#import "QuickImagePickerView.h"

#define kActionAnimationDuration        0.3
#define kActionBarHeight                50
#define kActionContentHeight            160
typedef NS_ENUM(NSInteger, ActionType){
    ActionTypeNone,
    ActionTypeRecordAudio,
    ActionTypePhoto,
    ActionTypeCamera
};

@class NotificationInputView;
@protocol NotificationInputDelegate <NSObject>
- (void)notificationInputDidWillChangeHeight:(CGFloat)height;
- (void)notificationInputPhoto:(NotificationInputView *)inputView;
- (void)notificationInputVideo:(NotificationInputView *)inputView;
@end

@interface NotificationInputView : UIView
{
    UIView*                     _actionView;
    UIButton*                   _sendButton;
    NotificationAudioRecordView* _recordView;
    QuickImagePickerView*       _photoView;
    NSMutableArray*             _actionButtonArray;
}
@property (nonatomic, assign)ActionType actionType;
@property (nonatomic, weak)id<NotificationInputDelegate> delegate;
@end
