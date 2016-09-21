//
//  MonthPickerView.h
//  LianZhiParent
//
//  Created by qingxu zhou on 16/9/21.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MonthPickerView : UIView
{
    UIButton*       _bgButton;
    UIView*         _contentView;
    UIDatePicker*   _datePicker;
}
@property(nonatomic, copy)void (^completion)(NSDate *date);
+ (void)showWithCompletion:(void (^)(NSDate *date))completion;
@end
