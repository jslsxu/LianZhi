//
//  StatisticsMonthHeaderView.h
//  LianZhiTeacher
//
//  Created by jslsxu on 16/12/23.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StatisticsMonthHeaderView : UIView
@property (nonatomic, strong)NSDate* date;
@property (nonatomic, assign)NSInteger class_attendance;
@property (nonatomic, copy)void (^dateChanged)();
@property (nonatomic, copy)void (^sortChanged)(NSInteger sort);
@end
