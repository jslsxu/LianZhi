//
//  HomeworkAnylizeVC.h
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/10/21.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"

@interface HomeworkSituation : TNBaseObject
@property (nonatomic, assign)NSInteger total;
@property (nonatomic, assign)NSInteger finished;
@property (nonatomic, assign)NSInteger marking;
@property (nonatomic, assign)NSInteger correct;
@property (nonatomic, assign)NSInteger answer;
@end

@interface HomeworkAnylizeVC : TNBaseViewController

@end
