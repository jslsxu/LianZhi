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
    UITouchScrollView*       _scrollView;
    AudioRecordView*            _recordView;
    UTPlaceholderTextView*        _textView;
}
@property (nonatomic, strong)NSData *amrData;
@property (nonatomic, assign)NSInteger duration;
@end
