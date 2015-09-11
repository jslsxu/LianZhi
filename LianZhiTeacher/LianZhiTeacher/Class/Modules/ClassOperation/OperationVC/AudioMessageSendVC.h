//
//  AudioMessageSendVC.h
//  LianZhiTeacher
//
//  Created by jslsxu on 15/9/10.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "MessageSendVC.h"

@interface AudioMessageSendVC : MessageSendVC<AudioRecordViewDelegate>
{
    AudioRecordView*    _recordView;
    UITextField*        _textField;
}
@end
