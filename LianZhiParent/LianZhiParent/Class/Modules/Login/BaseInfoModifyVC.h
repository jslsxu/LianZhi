//
//  BaseInfoModifyVC.h
//  LianZhiParent
//
//  Created by jslsxu on 15/4/8.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"

@interface BaseInfoModifyVC : TNBaseViewController<ActionSelectViewDelegate, UITextFieldDelegate>
{
    UITextField*    _nameField;
    UILabel*        _genderLabel;
}
@end
