//
//  HomeWorkRecordListVC.h
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/9/22.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "TNBaseTableViewController.h"
#import "HomeWorkEntity.h"
#import "HomeworkManager.h"
@interface HomeworkSendingItemCell : MGSwipeTableCell{
    UILabel*        _titleLabel;
    UIImageView*    _audioImageView;
    UIImageView*    _photoImageView;
    UIView*         _sepLine;
    CircleProgressView* _progressView;
    UIButton*       _cancelButton;
}
@property (nonatomic, strong)HomeWorkEntity*    sendEntity;
@property (nonatomic, strong)void (^uploadSuccess)();
@property (nonatomic, copy)void (^cancelCallback)();
@end

@interface HomeworkRecordItemCell : MGSwipeTableCell{
    UILabel*        _titleLabel;
    UILabel*        _timeLabel;
    UILabel*        _stateLabel;
    UIImageView*    _audioImageView;
    UIImageView*    _photoImageView;
    UIImageView*    _delayImageView;
    UIButton*       _revokeButton;
    UIView*         _sepLine;
}
@property (nonatomic, strong)HomeWorkEntity *homeworkEntity;
@property (nonatomic, copy)void (^revokeCallback)();
@end

@interface MySendHomeworkListModel : TNListModel

@end

@interface HomeWorkRecordListVC : TNBaseTableViewController

@end
