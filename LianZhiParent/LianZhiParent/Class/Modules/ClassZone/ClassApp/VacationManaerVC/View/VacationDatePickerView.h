//
//  DatePickerVC.h
//  RentCar
//
//  Created by jslsxu on 15/3/18.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"

typedef void(^DateSelectBlk)(NSDate *date);

@interface VacationDatePickerView : UIView
{
    UIButton*       _backgroundButton;
    UIView*         _contentView;
}
@property (nonatomic, strong)DateSelectBlk callBack;
- (instancetype)initWithFrame:(CGRect)frame andDate:(NSDate *)date minimumDate:(NSDate *)minDate;
- (void)show;
@end
