//
//  NotificationRecordVC.h
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/7/31.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "TNBaseTableViewController.h"

@interface NotificationRecordItemCell : DAContextMenuCell{
    UILabel*        _titleLabel;
    UILabel*        _timeLabel;
    UIImageView*    _audioImageView;
    UIImageView*    _photoImageView;
    UIImageView*    _videoImageView;
    UIView*         _sepLine;
}

@end

@interface NotificationRecordVC : DAContextMenuTableViewController
- (void)clear;
@end
