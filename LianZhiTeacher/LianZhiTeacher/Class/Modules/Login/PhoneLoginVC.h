//
//  RegisterVC.h
//  LianZhiParent
//
//  Created by jslsxu on 14/12/17.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"

@interface PhoneLoginVC : TNBaseViewController<UITextFieldDelegate>
{
    LZTextField*        _phoneNumField;
    UIButton*           _registerButton;
}
@property (nonatomic, copy)LoginCompletion loginCallBack;
@end
