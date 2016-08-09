//
//  NotificationTargetContentView.h
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/7/19.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NotificationSendTargetView.h"
#import "NotificationContentBaseView.h"
@interface NotificationTargetContentView : NotificationContentBaseView{
    UILabel*                        _numLabel;
    NotificationSendTargetView*     _memberView;
    UIButton*                       _addButton;
}
@property (nonatomic, strong)NSArray *targets;
@property (nonatomic, copy)void (^addBlk)();
@end
