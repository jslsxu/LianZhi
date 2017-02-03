//
//  StudentAttendanceHeaderView.h
//  LianZhiTeacher
//
//  Created by jslsxu on 16/12/21.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StudentAttendanceDetail.h"
@interface StudentAttendanceHeaderView : UIView
@property (nonatomic, strong)NSDate* date;
@property (nonatomic, strong)StudentAttendanceDetailInfo* info;
@property (nonatomic, strong)StudentInfo* studentInfo;
@end
