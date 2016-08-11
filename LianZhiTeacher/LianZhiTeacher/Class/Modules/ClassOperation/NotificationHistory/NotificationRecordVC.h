//
//  NotificationRecordVC.h
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/7/31.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "TNBaseTableViewController.h"
#import "NotificationItem.h"
@interface NotificationRecordItemCell : DAContextMenuCell{
    UILabel*        _titleLabel;
    UILabel*        _timeLabel;
    UIImageView*    _audioImageView;
    UIImageView*    _photoImageView;
    UIImageView*    _videoImageView;
    UIView*         _sepLine;
}
@property (nonatomic, strong)NotificationItem *notificationItem;
@end

@interface NotificationRecordVC : DAContextMenuTableViewController
- (void)clear;
@end
