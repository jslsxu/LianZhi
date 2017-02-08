//
//  RequestVacationVC.h
//  LianZhiParent
//
//  Created by jslsxu on 15/5/26.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"
#import "VacationDatePickerView.h"
#import "ChildInfo.h"
@interface RequestVacationVC : TNBaseViewController
@property (nonatomic, strong)ClassInfo* classInfo;
@property (nonatomic, copy)void (^completion)();
@end
