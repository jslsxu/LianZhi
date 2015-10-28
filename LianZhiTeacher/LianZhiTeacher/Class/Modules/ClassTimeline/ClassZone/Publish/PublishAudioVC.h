//
//  PublishAudioVC.h
//  LianZhiParent
//
//  Created by jslsxu on 14/12/19.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "PublishBaseVC.h"
#import "UITouchScrollView.h"
@interface PublishAudioVC : PublishBaseVC<AudioRecordViewDelegate>
{
    UITouchScrollView*          _scrollView;
    AudioRecordView*            _recordView;
    UTPlaceholderTextView*      _textView;
}
@end
