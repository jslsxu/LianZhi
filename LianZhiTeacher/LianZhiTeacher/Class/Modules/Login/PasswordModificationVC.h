//
//  PasswordModificationVC.h
//  LianZhiParent
//
//  Created by jslsxu on 14/12/19.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"

typedef void(^ModificationCallBack)();
@interface PasswordModificationVC : TNBaseViewController<UITextFieldDelegate>
{
    LZTextField*    _firstField;
    LZTextField*    _secondField;
    UIButton*       _confirmButton;
}

@property (nonatomic, copy)ModificationCallBack callback;
@end
