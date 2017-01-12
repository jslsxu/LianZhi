//
//  StudentsAttendanceHeaderView.h
//  LianZhiTeacher
//
//  Created by jslsxu on 16/12/22.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StudentsAttendanceHeaderView : UIView
@property (nonatomic, strong)UILabel* titleLabel;
@property (nonatomic, strong)UIButton* nameButton;
@property (nonatomic, strong)UIButton* attendanceButton;
@property (nonatomic, strong)UIButton* offButton;
@property (nonatomic, assign)NSInteger titleHidden;
@property (nonatomic, copy)void (^sortCallback)(NSInteger sort);
@end
