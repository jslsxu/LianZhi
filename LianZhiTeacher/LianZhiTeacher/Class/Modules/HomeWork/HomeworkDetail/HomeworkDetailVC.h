//
//  HomeworkDetailVC.h
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/10/10.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"
extern NSString *const kHomeworkReadNumChangedNotification;
@interface HomeworkDetailVC : TNBaseViewController
@property (nonatomic, copy)NSString *hid;
@property (nonatomic, assign)BOOL hasNew;
@property (nonatomic, copy)void (^deleteCallback)(NSString *hid);
@property (nonatomic, copy)void (^readCallback)();
@end
