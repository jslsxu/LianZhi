//
//  PublishHomeWorkAudioVC.h
//  LianZhiTeacher
//
//  Created by jslsxu on 15/10/31.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "PublishHomeWorkBaseVC.h"

@interface PublishHomeWorkAudioVC : PublishHomeWorkBaseVC
{
    UITouchScrollView*  _scrollView;
    AudioRecordView*    _recordView;
}
@property (nonatomic, copy)void (^completion)(NSData *amrData, NSInteger timeSpan);
@end
