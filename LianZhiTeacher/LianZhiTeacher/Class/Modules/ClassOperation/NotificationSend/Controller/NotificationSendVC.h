//
//  NotificationSendVC.h
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/6/30.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"
#import "NotificationTargetContentView.h"
#import "NotificationSendChoiceView.h"
#import "NotificationCommentView.h"
#import "NotificationInputView.h"
#import "NotificationVoiceView.h"
#import "NotificationPhotoView.h"
#import "NotificationVideoView.h"
@interface NotificationSendVC : TNBaseViewController
{
    UIScrollView*                   _scrollView;
    NotificationInputView*          _inputView;
}
@end
