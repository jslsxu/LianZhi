//
//  HomeworkNotificationCell.h
//  LianZhiParent
//
//  Created by qingxu zhou on 16/10/24.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "TNTableViewCell.h"
#import "HomeworkNotificationItem.h"
@interface HomeworkNotificationExtraInfoView : UIView{
    UILabel*        _courseLabel;
    UIImageView*    _imageTypeView;
    UIImageView*    _voiceTypeView;
    UIView*         _redDot;
    UILabel*        _statusLabel;
    UIImageView*    _rightArrow;
}
@property (nonatomic, strong)HomeworkNotificationItem *homeworkItem;
@end

@interface HomeworkNotificationCell : TNTableViewCell
{
    UIView*     _bgView;
    AvatarView* _avatarView;
    UILabel*    _nameLabel;
    UILabel*    _roleLabel;
    UILabel*    _timeLabel;
    UILabel*    _contentLabel;
    UILabel*    _endTimeLabel;
    HomeworkNotificationExtraInfoView*  _extraInfoView;
}
@end
