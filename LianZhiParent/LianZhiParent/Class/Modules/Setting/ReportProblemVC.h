//
//  ReportProblemVC.h
//  LianZhiTeacher
//
//  Created by jslsxu on 15/2/6.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"

@interface ReportProblemVC : TNBaseViewController<UITextFieldDelegate,UITextViewDelegate, ActionSelectViewDelegate>
{
    NSArray*        _sourceArray;
    LZTextField*    _contactField;
    LZTextField*    _groupField;
    UTPlaceholderTextView*     _textView;
    UILabel*        _numLabel;
    UIButton*       _contactButton;
    UILabel*        _hintLabel;
    UIButton*       _sendButton;
}
@property (nonatomic, assign)BOOL contactMe;
@property (nonatomic, assign)NSInteger type;
@end
