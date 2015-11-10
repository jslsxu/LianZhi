//
//  MessageOperationVC.h
//  LianZhiTeacher
//
//  Created by jslsxu on 15/1/6.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "MessageSendVC.h"

@interface TextMessageSendVC : MessageSendVC<UITextViewDelegate, AudioRecordViewDelegate>
{
    UTPlaceholderTextView*  _textView;
    UILabel*                _numLabel;
//    UIButton*               _checkButton;
//    UILabel*                _hintLabel;
}
@property (nonatomic, strong)NSDictionary *targetDic;
@end
