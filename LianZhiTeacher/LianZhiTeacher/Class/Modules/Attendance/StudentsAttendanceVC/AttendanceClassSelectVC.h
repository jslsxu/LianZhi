//
//  ClassSelectVC.h
//  LianZhiTeacher
//
//  Created by jslsxu on 17/1/12.
//  Copyright © 2017年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"

@interface AttendanceClassSelectVC : TNBaseViewController
@property (nonatomic, strong)NSArray* classArray;
@property (nonatomic, copy)void (^classSelectCallback)(ClassInfo* classInfo);
@end
