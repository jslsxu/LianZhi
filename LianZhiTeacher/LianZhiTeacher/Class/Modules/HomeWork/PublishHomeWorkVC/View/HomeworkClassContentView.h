//
//  HomeworkClassContentView.h
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/10/2.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "NotificationContentBaseView.h"
#import "HomeworkClassSendView.h"
@interface HomeworkClassContentView : NotificationContentBaseView
{
    UILabel*                        _numLabel;
    HomeworkClassSendView*          _memberView;
    UIButton*                       _addButton;
}
@property (nonatomic, strong)NSArray *targets;
@property (nonatomic, copy)void (^addBlk)();

@end
