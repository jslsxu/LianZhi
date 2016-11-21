//
//  GrowthTimelineCell.h
//  LianZhiParent
//
//  Created by jslsxu on 15/1/2.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "TNTableViewCell.h"
//#import "GrowthTimelineModel.h"

@interface LearningTasksCell : TNTableViewCell
{
    UILabel*        _dateLabel;
    UILabel*        _titleLabel;
    UIButton*        _statusBtn;
    UIView*        _totalView;
    UILabel*        _totalLbl;

    UILabel*        _contentLabel;
 
    UIView*         _sepLine;
    UIButton*        startTest;

}
@end
