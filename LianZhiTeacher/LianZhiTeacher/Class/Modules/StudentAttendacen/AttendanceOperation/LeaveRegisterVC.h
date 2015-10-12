//
//  LeaveRegisterVC.h
//  LianZhiTeacher
//  登记
//  Created by jslsxu on 15/10/8.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"

@interface LeaveRegisterVC : TNBaseViewController
{
    UILabel*    _startLabel;
    UILabel*    _endLabel;
    UISegmentedControl*     _typeSegment;
    UTPlaceholderTextView*  _textView;
}
@property (nonatomic, strong)StudentInfo* studentInfo;
@end
