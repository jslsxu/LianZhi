//
//  MessageOperationVC.h
//  LianZhiTeacher
//
//  Created by jslsxu on 15/1/6.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"

@interface MessageOperationVC : TNBaseViewController<UITextViewDelegate, AudioRecordViewDelegate>
{
    UIImageView*            _bgImageView;
    UIImageView* _inputBG;
    UTPlaceholderTextView*     _textView;
    UILabel*        _numLabel;
    
    AudioRecordView*    _recordView;
    UIButton *      _sendButton;
    
    UIButton*   _switchButton;
}
@property (nonatomic, strong)NSDictionary *targetDic;
@end
