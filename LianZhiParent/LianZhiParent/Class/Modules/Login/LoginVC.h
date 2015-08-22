//
//  LoginVC.h
//  LianZhiParent
//
//  Created by jslsxu on 14/12/17.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

typedef void(^LoginCompletion)(BOOL loginSuccess, BOOL loginCancel);

@interface LoginVC : TNBaseViewController<UITextFieldDelegate>
{
    UITextField*    _userNameField;
    UITextField*    _passwordField;
}

+ (void)presentLoginVCAnimation:(BOOL)animated completion:(LoginCompletion)compleciton;

@end
