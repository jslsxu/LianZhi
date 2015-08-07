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
    AvatarView* _avatar;
    UIButton*   _preButton;
    UILabel*    _curMonth;
    UIButton*   _nextButton;
}
@property (nonatomic, strong)NSDate *date;
@property (nonatomic, weak)id<GrowthDatePickerDelegate> delegate;
@end

@interface GrowthTimelineVC : TNBaseTableViewController<GrowthDatePickerDelegate>
{
    GrowthTimelineHeaderView *  _headerView;
    UIView*                     _verLine;
}
@property (nonatomic, strong)NSDate *date;
@property (nonatomic, strong)ClassInfo *classInfo;
@end
