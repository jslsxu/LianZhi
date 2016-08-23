//
//  GrowthTimelineVC.h
//  LianZhiParent
//
//  Created by jslsxu on 15/1/2.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "TNBaseTableViewController.h"

@protocol GrowthDatePickerDelegate <NSObject>
- (void)growthDatePickerFinished:(NSDate *)date;

@end

@interface GrowthTimelineHeaderView : UIView
{
    UIButton*   _preButton;
    UILabel*    _curMonth;
    UIButton*   _nextButton;
}
@property (nonatomic, copy)NSDate *date;
@property (nonatomic, weak)id<GrowthDatePickerDelegate> delegate;
@end

@interface GrowthTimelineVC : TNBaseTableViewController<GrowthDatePickerDelegate>
{
    GrowthTimelineHeaderView *  _headerView;
}
@property (nonatomic, copy)NSString *classID;
@end
