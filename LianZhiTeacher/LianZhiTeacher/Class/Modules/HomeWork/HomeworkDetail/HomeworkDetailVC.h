//
//  HomeworkDetailVC.h
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/10/10.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"

@interface HomeworkDetailVC : TNBaseViewController
@property (nonatomic, copy)NSString *hid;
@property (nonatomic, copy)void (^deleteCallback)(NSString *hid);
@end
