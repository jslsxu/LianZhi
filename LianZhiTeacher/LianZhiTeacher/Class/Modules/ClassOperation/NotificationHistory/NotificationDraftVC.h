//
//  NotificationDraftVC.h
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/7/31.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"
#import "NotificationDraftManager.h"
@interface NotificationDraftItemCell : TNTableViewCell
{
    UILabel*        _titleLabel;
    UILabel*        _timeLabel;
    UIImageView*    _audioImageView;
    UIImageView*    _photoImageView;
    UIImageView*    _videoImageView;
    UIView*         _sepLine;
}
@property (nonatomic, strong)NotificationSendEntity* notification;
@end

@interface NotificationDraftVC : TNBaseViewController
- (void)clear;
@end
