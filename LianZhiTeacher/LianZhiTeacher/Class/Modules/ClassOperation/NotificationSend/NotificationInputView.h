//
//  NotificationInputView.h
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/6/30.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NotificationRecordView.h"

@class NotificationInputView;
@protocol NotificationInputDelegate <NSObject>

- (void)notificationInputPhoto:(NotificationInputView *)inputView;
- (void)notificationInputVideo:(NotificationInputView *)inputView;

@end

@interface NotificationInputView : UIView
{
    UIView*                 _actionView;
    NotificationRecordView* _recordView;
}
@property (nonatomic, weak)id<NotificationInputDelegate> delegate;
@end
