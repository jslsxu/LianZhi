//
//  RegisterAuthVC.h
//  LianZhiTeacher
//
//  Created by jslsxu on 15/9/26.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"

@interface RegisterAuthVC : TNBaseViewController
{
    UIButton*       _retrieveButton;
    LZTextField*    _authCodeFeild;
    UIButton*       _nextButton;
}
@property (nonatomic, copy)NSString *mobile;
@property (nonatomic, copy)NSString *name;
@property (nonatomic, copy)NSString *school;
@property (nonatomic, copy)NSString *area;
@end
