//
//  CalendarView.h
//  YouYao
//
//  Created by jslsxu on 15/6/10.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSDate+convenience.h"
#import "NSMutableArray+convenience.h"
#import "UIColor+expanded.h"
#import "UIView+convenience.h"
#import "VacationHistoryModel.h"
@protocol CalendarDelegate <NSObject>
@optional
- (void)calendarViewSelectDate:(NSDate *)date item:(VacationHistoryItem *)vacationItem;
- (void)calendarViewFrameDidChanged;

@end

@interface CalendarGridCell : UICollectionViewCell
{
    UILabel*        _dateLabel;
    UIImageView*    _statusImageView;
    UIView*         _bgView;
}
@property (nonatomic, assign)BOOL curMonth;
@property (nonatomic, strong)NSDate *date;
@property (nonatomic, weak)VacationHistoryItem *vacationHistoryItem;
@end

@interface CalendarView : UIView<UICollectionViewDataSource, UICollectionViewDelegate>
{
    UIView*                     _weekdayView;
    UICollectionViewFlowLayout* _flowLayout;
    UICollectionView*           _collectionView;
}
@property (nonatomic, strong)NSDate *curMonth;
@property (nonatomic, strong)NSArray *vacationArray;
@property (nonatomic, weak)id<CalendarDelegate> delegate;
@end
