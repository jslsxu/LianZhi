//
//  AttendanceDatePickerView.h
//  LianZhiTeacher
//
//  Created by jslsxu on 15/10/7.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AttendanceDatePickerDelegate <NSObject>

- (void)attendancePickerDidPickAtDate:(NSDate *)date;

@end

@interface AttendanceDatePickerView : UIView
{
    UIButton*   _preButton;
    UIButton*   _nextButton;
    UILabel*    _dateLabel;
}
@property (nonatomic, strong)NSDate *date;
@property (nonatomic, weak)id<AttendanceDatePickerDelegate> delegate;
@end
