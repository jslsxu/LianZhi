//
//  DatePickerView.h
//  LianZhiTeacher
//
//  Created by jslsxu on 15/1/19.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DatePickerDelegate <NSObject>
- (void)growthDatePickerFinished:(NSDate *)date;

@end

@interface DatePickerView : UIView
{
    UIButton*   _preButton;
    UILabel*    _dateLabel;
    UIButton*   _nextButton;
}
@property (nonatomic, strong)NSDate *date;
@property (nonatomic, weak)id<DatePickerDelegate> delegate;
- (NSString *)dateStr;
@end
