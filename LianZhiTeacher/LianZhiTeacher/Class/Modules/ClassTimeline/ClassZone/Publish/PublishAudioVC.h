//
//  PublishAudioVC.h
//  LianZhiParent
//
//  Created by jslsxu on 14/12/19.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "PublishBaseVC.h"

@interface PublishAudioVC : PublishBaseVC<AudioRecordViewDelegate>
{
    UIImageView*    _bgImageView;
    UIImageView*    _whiteBG;
    
    UIView*         _sepLine;
    UITextField*    _textField;
    UIButton*       _sendButton;
    AudioRecordView*    _recordView;
}
@end
