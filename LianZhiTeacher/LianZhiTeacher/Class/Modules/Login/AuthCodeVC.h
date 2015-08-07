//
//  AuthCodeVC.h
//  LianZhiParent
//
//  Created by jslsxu on 14/12/17.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"

@interface AuthCodeVC : TNBaseViewController<UITextFieldDelegate>
{
    LZTextField*    _authCodeField;
    LZTextField*    _nameField;
    UIButton*       _retrieveButton;
    UIButton*       _authButton;
    NSInteger       _defaultRemain;
}
@property (nonatomic, copy)NSString *mobile;
@property (nonatomic, copy)LoginCompletion loginCallBack;
@end
