//
//  HomeworkPreviewVC.h
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/11/1.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"
#import "HomeWorkEntity.h"
@interface HomeworkPreviewVC : TNBaseViewController
@property (nonatomic, strong)HomeWorkEntity *homeworkEntity;
@property (nonatomic, copy)void (^sendCallback)();
@end
