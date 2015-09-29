//
//  DatePickerView.h
//  LianZhiParent
//
//  Created by jslsxu on 15/2/3.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SettingDatePickerType){
    SettingDatePickerTypeDate = 0,
    SettingDatePickerTypeTime
};
typedef void(^DatePickerBlk)(NSString *dateStr);
@interface SettingDatePickerView : UIView
{
    UIButton*           _coverButton;
    UIView*             _contentView;
    UIButton*           _cancelButton;
    UIButton*           _confirmButton;
    UIDatePicker*       _datePicker;
}
@property (nonatomic, readonly)UIDatePicker *datePicker;
@property (nonatomic, copy)DatePickerBlk blk;
@property (nonatomic, assign)SettingDatePickerType pickerType;
- (instancetype)initWithType:(SettingDatePickerType)pickerType;
- (void)show;
@end
