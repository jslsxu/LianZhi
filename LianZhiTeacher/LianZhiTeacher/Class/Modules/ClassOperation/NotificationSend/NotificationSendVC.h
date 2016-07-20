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
#import "NotificationInputView.h"
@interface NotificationSendVC : TNBaseViewController
{
    UIScrollView*                   _scrollView;
    NotificationTargetContentView*  _targetContentView;
    NotificationSendChoiceView*     _smsChoiceView;
    NotificationSendChoiceView*     _timerSendView;
    NotificationInputView*          _inputView;
    
}
@end
