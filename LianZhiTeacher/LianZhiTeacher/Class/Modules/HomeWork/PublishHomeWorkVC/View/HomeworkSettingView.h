//
//  HomeworkSettingView.h
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/10/10.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeWorkEntity.h"
@interface HomeworkSettingView : UIView
@property (nonatomic, strong)HomeWorkEntity*    homeworkEntity;
@property (nonatomic, copy)void (^settingClick)();
@end
