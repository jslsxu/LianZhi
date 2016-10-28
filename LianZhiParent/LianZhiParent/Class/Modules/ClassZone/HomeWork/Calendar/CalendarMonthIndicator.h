//
//  CalendarMonthIndicator.h
//  LianZhiParent
//
//  Created by qingxu zhou on 16/10/28.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CalendarMonthDelegate <NSObject>

- (void)calendarPre;
- (void)calendarNext;

@end

@interface CalendarMonthIndicator : UIView
@property (nonatomic, strong)NSDate* date;
@property (nonatomic, weak)id<CalendarMonthDelegate> delegate;
@end
