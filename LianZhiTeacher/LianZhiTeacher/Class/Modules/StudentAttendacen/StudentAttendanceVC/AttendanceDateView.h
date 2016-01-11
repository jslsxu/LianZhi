//
//  AttendanceDateView.h
//  LianZhiTeacher
//
//  Created by jslsxu on 16/1/11.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AttendanceDateDelegate <NSObject>
- (void)growthDatePickerFinished:(NSDate *)date;

@end

@interface AttendanceDateView : UIView
{
    UIButton*   _preButton;
    UILabel*    _dateLabel;
    UIButton*   _nextButton;
}
@property (nonatomic, strong)NSDate *date;
@property (nonatomic, weak)id<AttendanceDateDelegate> delegate;
- (NSString *)dateStr;
@end
