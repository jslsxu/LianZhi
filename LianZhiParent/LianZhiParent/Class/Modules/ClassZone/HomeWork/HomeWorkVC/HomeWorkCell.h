//
//  HomeWorkCell.h
//  LianZhiParent
//
//  Created by jslsxu on 15/10/26.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "TNTableViewCell.h"
#import "HomeworkItem.h"
@interface HomeworkExtraInfoView : UIView{
    UILabel*        _courseLabel;
    UIImageView*    _imageTypeView;
    UIImageView*    _voiceTypeView;
    UIImageView*    _videoTypeView;
    UIView*         _redDot;
    UILabel*        _statusLabel;
    UIImageView*    _rightArrow;
}
@property (nonatomic, strong)HomeworkItem *homeworkItem;
@end

@interface HomeWorkCell : TNTableViewCell
{
    UIView*     _bgView;
    AvatarView* _avatarView;
    UILabel*    _nameLabel;
    UILabel*    _roleLabel;
    UILabel*    _timeLabel;
    UILabel*    _contentLabel;
    UILabel*    _endTimeLabel;
    HomeworkExtraInfoView*  _extraInfoView;
}
@end
