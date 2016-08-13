//
//  ActionFadeView.h
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/7/27.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeatherView : UIView{
    UILabel*    _dayLabel;
    UILabel*    _weekdayLabel;
    UILabel*    _monthLabel;
    UILabel*    _temperatureLabel;
}

@end

typedef NS_ENUM(NSInteger, ActionFadeViewType){
    ActionTypeSendNotification,
    ActionTypeNewChat,
    ActionTypeStudentAttendance,
};
@interface ActionFadeView : UIView
+ (void)showActionView;
@end