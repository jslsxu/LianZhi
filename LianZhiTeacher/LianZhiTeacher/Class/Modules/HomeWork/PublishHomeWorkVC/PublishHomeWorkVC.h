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
@interface PublishHomeWorkVC : TNBaseViewController{
    UITouchScrollView*              _scrollView;
    NotificationInputView*          _inputView;
}
- (instancetype)initWithHomeWorkEntity:(HomeWorkEntity *)homeWorkEntity;
@end
