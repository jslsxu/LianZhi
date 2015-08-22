//
//  AuthCodeVC.h
//  LianZhiParent
//
//  Created by jslsxu on 14/12/17.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"
#import "LoginVC.h"
@interface AuthCodeVC : TNBaseViewController<UITextFieldDelegate>
{
    LZTextField*    _mobileField;
    LZTextField*    _authCodeField;
    LZTextField*    _nameField;
    UIButton*       _retrieveButton;
    UIButton*       _nextButton;
    NSInteger       _defaultRemain;
}
@property (nonatomic, copy)NSString *mobile;
@property (nonatomic, copy)LoginCompletion loginCallBack;
@end
