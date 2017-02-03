//
//  StudentAttendanceHeaderView.h
//  LianZhiTeacher
//
//  Created by jslsxu on 16/12/21.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AttendanceDetailResponse.h"
@interface StudentAttendanceHeaderView : UIView
@property (nonatomic, strong)AttendanceInfo* info;
@property (nonatomic, strong)NSDate* date;
@end
