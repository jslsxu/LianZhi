//
//  VacationHistoryVC.h
//  LianZhiParent
//
//  Created by jslsxu on 15/5/27.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "TNBaseTableViewController.h"
#import "MonthIndicatorView.h"
#import "CalendarView.h"
@interface VacationHistoryVC : TNBaseTableViewController
{
    UILabel*            _descLabel;
    MonthIndicatorView* _monthIndicator;
    CalendarView*       _calendarView;
}
@end
