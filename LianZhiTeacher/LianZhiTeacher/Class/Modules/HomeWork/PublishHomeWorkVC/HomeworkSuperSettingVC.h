//
//  HomeworkSuperSettingVC.h
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/10/10.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"
#import "HomeWorkEntity.h"
@interface HomeworkSuperSettingCell : TNTableViewCell
@property (nonatomic, strong)UIView* actionView;
@end

@interface HomeworkSuperSettingVC : TNBaseViewController
@property (nonatomic, strong)HomeWorkEntity* homeworkEntity;
@property (nonatomic, copy)void (^homeworkSettingChanged)();
@end
