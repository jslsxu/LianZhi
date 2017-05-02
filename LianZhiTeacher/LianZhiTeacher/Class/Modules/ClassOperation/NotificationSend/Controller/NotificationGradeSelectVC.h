//
//  NotificationGradeSelectVC.h
//  LianZhiTeacher
//
//  Created by jslsxu on 2017/4/29.
//  Copyright © 2017年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"

@interface NotificationGradeCell : TNTableViewCell
@property (nonatomic, strong)GradeInfo* gradeInfo;
@property (nonatomic, assign)BOOL chosen;
@end

@interface NotificationGradeSelectVC : TNBaseViewController

@end
