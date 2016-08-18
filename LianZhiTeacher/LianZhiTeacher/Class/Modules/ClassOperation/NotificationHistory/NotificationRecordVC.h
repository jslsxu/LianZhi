//
//  NotificationRecordVC.h
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/7/31.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "TNBaseTableViewController.h"
#import <MGSwipeTableCell/MGSwipeTableCell.h>
#import "MySendNotificationModel.h"
#import "NotificationSendEntity.h"
#import "CircleProgressView.h"
@interface NotificationSendingItemCell : MGSwipeTableCell{
    UILabel*        _titleLabel;
    UIImageView*    _audioImageView;
    UIImageView*    _photoImageView;
    UIImageView*    _videoImageView;
    UIView*         _sepLine;
    CircleProgressView* _progressView;
    UIButton*       _cancelButton;
}
@property (nonatomic, strong)NotificationSendEntity*    sendEntity;
@property (nonatomic, strong)void (^uploadSuccess)();
@property (nonatomic, copy)void (^cancelCallback)();
@end

@interface NotificationRecordItemCell : MGSwipeTableCell{
    UILabel*        _titleLabel;
    UILabel*        _timeLabel;
    UILabel*        _stateLabel;
    UIImageView*    _audioImageView;
    UIImageView*    _photoImageView;
    UIImageView*    _videoImageView;
    UIImageView*    _delayImageView;
    UIButton*       _revokeButton;
    UIView*         _sepLine;
}
@property (nonatomic, strong)NotificationItem *notificationItem;
@property (nonatomic, copy)void (^revokeCallback)();
@end

@interface NotificationRecordVC : TNBaseTableViewController
- (void)clear;
@end
