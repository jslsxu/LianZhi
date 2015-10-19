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
    UIScrollView*               _scrollView;
    AudioRecordView*            _recordView;
    UTPlaceholderTextView*        _textView;
}
@property (nonatomic, strong)NSData *amrData;
@property (nonatomic, assign)NSInteger duration;
@end
