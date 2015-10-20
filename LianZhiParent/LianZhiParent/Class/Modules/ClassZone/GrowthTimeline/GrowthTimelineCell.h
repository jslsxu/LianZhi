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
    UIView*         _bgView;
    UIView*         _statusView;
    UIView*         _contentBGView;
    UILabel*        _contentLabel;
    NSMutableArray* _statusArray;
    UIView*         _sepLine;
    UILabel*        _authorLabel;
    UILabel*        _timeLabel;
}
@end
