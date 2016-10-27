//
//  HomeworkAddExplainVC.h
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/10/10.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"
#import "HomeworkExplainEntity.h"

@interface HomeworkAddExplainVC : TNBaseViewController
@property (nonatomic, strong)HomeworkExplainEntity* explainEntity;
@property (nonatomic, copy)void (^addExplainFinish)(HomeworkExplainEntity *explainEntity);
@end
