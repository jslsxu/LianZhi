//
//  NotificationRecordVC.h
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/7/31.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "TNBaseTableViewController.h"

@interface NotificationItem : TNBaseObject
@property (nonatomic, copy)NSString *nid;
@property (nonatomic, copy)NSString *words;
@property (nonatomic, copy)NSString *create_time;
@property (nonatomic, strong)AudioItem* voice;
@property (nonatomic, strong)NSArray<PhotoItem*> *pictures;

- (BOOL)hasImage;
- (BOOL)hasAudio;
- (BOOL)hasVideo;
@end

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
