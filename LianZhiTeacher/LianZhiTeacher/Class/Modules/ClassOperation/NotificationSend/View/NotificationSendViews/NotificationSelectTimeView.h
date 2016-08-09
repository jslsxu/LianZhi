//
//  NotificationSelectTimeView.h
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/7/20.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NotificationContentBaseView.h"
@interface NotificationSelectTimeView : NotificationContentBaseView{
    UIButton*       _bgButton;
    UIView*         _contentView;
    UIDatePicker*   _datePicker;
}
@property(nonatomic, copy)void (^completion)( NSDate *date);
+ (void)showWithCompletion:(void (^)(NSDate *date))completion;
@end
