//
//  GrowthTimelineCell.h
//  LianZhiParent
//
//  Created by jslsxu on 15/1/2.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "TNTableViewCell.h"
#import "GrowthTimelineModel.h"
@interface GrowthTimelineCell : TNTableViewCell
{
    UILabel*        _dateLabel;
    UIImageView*    _dot;
    UIImageView*    _bgImageView;
    UIImageView*    _feeling;
    UIImageView*    _toilet;
    UIImageView*    _temparature;
    UILabel*        _waterLabel;
    UILabel*        _sleepLabel;
    UIImageView*    _contentBG;
    UILabel*        _contentLabel;
    UILabel*        _authorLabel;
    UILabel*        _timeLabel;
}
@end
