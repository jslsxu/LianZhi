//
//  VacationHistoryCell.h
//  LianZhiParent
//
//  Created by jslsxu on 15/5/27.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "TNTableViewCell.h"

@interface VacationHistoryCell : TNTableViewCell
{
    AvatarView*     _avatar;
    UIImageView*    _redDot;
    UILabel*        _nameLabel;
    UILabel*        _vacationTypeLabel;
    UILabel*        _durationLabel;
    UILabel*        _stateLabel;
    UILabel*        _timeLabel;
}
@end
