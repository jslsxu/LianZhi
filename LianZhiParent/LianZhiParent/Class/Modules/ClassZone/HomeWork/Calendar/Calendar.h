//
//  Calendar.h
//  LianZhiParent
//
//  Created by qingxu zhou on 16/10/10.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CalendarType){
    CalendarTypeMonth = 0,
    CalendarTypeWeek,
};

@protocol CalendarDelegate <NSObject>
@optional
- (void)calendarHeightWillChange:(CGFloat)height;

@end

@interface CalendarDayView : UICollectionViewCell{
    UILabel*    _dayLabel;
    UIView*     _curDateIndicator;
}
@property (nonatomic, strong)NSDate *date;
@property (nonatomic, assign)BOOL   isChosen;
@property (nonatomic, assign)BOOL   isCurMonth;
@end

@interface Calendar : UIView
@property (nonatomic, assign)CalendarType calendarType;
@property (nonatomic, weak)id<CalendarDelegate> delegate;
@property (nonatomic, strong)NSDate*    date;
- (instancetype)initWithDate:(NSDate *)date;
@end
