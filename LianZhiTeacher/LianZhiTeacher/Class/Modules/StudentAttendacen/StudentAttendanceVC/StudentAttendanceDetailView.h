//
//  StudentAttendanceDetailView.h
//  LianZhiTeacher
//
//  Created by jslsxu on 16/1/9.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StudentAttendanceModel.h"
@interface StudentAttendanceDetailView : UIView
{
    UIButton*     _bgButton;
    UIView*         _contentView;
}
@property (nonatomic, strong)StudentAttendanceItem *leaveItem;
- (instancetype)initWithVacationItem:(StudentAttendanceItem *)leaveItem;
- (void)show;
@end
