//
//  NotificationInputView.h
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/6/30.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NotificationSimpleAudioRecordView.h"
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
- (void)notificationInputQuickPhoto:(NSArray *)photoArray fullImage:(BOOL)isFullImage;
- (void)notificationInputAudio:(NotificationInputView *)inputView audioItem:(AudioItem *)audioItem;
- (void)notificationInputSend;
@end

@interface NotificationInputView : UIView
{
    UIView*                         _actionView;
    UIButton*                       _sendButton;
    NotificationSimpleAudioRecordView* _recordView;
    QuickImagePickerView*           _photoView;
    NSMutableArray*                 _actionButtonArray;
}
@property (nonatomic, copy)NSInteger (^photoNum)();
@property (nonatomic, copy)NSInteger (^videoNum)();
@property (nonatomic, copy)BOOL (^canRecord)();
@property (nonatomic, assign)BOOL onlyPhotoLibrary;
@property (nonatomic, assign)BOOL onlyPhoto;
@property (nonatomic, assign)ActionType actionType;
@property (nonatomic, assign)BOOL sendHidden;
@property (nonatomic, assign)BOOL forward;
@property (nonatomic, weak)id<NotificationInputDelegate> delegate;
@end
