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

typedef NS_ENUM(NSInteger, NotificationSendType){
    NotificationSendNormal = 0,     //正常发送
    NotificationSendForward ,       //转发
    NotificationSendDraft,          //从草稿进入
    NotificationSendEdit            //编辑
};

@interface NotificationSendVC : TNBaseViewController
{
    UITouchScrollView*                   _scrollView;
    NotificationInputView*          _inputView;
}
@property (nonatomic, assign)NotificationSendType sendType;
- (instancetype)initWithSendEntity:(NotificationSendEntity *)sendEntity;
@end
