//
//  PasswordModifyVC.h
//  LianZhiParent
//
//  Created by jslsxu on 15/1/12.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"

@interface PasswordModifyVC : TNBaseViewController<UITextFieldDelegate>
{
    LZTextField*    _originalPasswordField;
    LZTextField*    _newPasswordField;
    LZTextField*    _confirmPasswordField;
}
@end
