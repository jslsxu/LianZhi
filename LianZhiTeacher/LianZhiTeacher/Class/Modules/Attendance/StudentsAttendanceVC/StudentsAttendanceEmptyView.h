//
//  StudentsAttendanceEmptyView.h
//  LianZhiTeacher
//
//  Created by jslsxu on 17/1/4.
//  Copyright © 2017年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StudentsAttendanceEmptyView : UIView
@property (nonatomic, strong)NSDate *date;
@property (nonatomic, copy)void (^editAttendanceCallback)();
@end
