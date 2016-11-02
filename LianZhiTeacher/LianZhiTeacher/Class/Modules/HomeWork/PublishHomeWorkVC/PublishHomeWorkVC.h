//
//  PublishHomeWorkVC.h
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/9/22.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"
#import "NotificationInputView.h"
#import "HomeWorkEntity.h"
typedef NS_ENUM(NSInteger, HomeworkSendType){
    HomeworkSendNormal = 0,     //正常发送
    HomeworkSendDraft,          //从草稿进入
    HomeworkSendEdit            //编辑
};

@interface PublishHomeWorkVC : TNBaseViewController{
    UITouchScrollView*              _scrollView;
    NotificationInputView*          _inputView;
}
@property (nonatomic, assign)HomeworkSendType sendType;
- (instancetype)initWithHomeWorkEntity:(HomeWorkEntity *)homeWorkEntity;
@end
