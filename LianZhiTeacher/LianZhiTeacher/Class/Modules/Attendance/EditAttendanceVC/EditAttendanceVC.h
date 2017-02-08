//
//  EditAttendanceVC.h
//  LianZhiTeacher
//
//  Created by jslsxu on 16/12/22.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"

extern NSString* kEditAttendanceNotification;

@interface EditAttendanceVC : TNBaseTableViewController
@property (nonatomic, strong)ClassInfo* classInfo;
@property (nonatomic, strong)NSDate* date;
@property (nonatomic, copy)void (^editFinished)();
@property (nonatomic, strong)NSArray* studentAttendanceArray;
@end
