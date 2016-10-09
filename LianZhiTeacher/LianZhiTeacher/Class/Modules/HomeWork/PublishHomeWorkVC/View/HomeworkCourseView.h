//
//  HomeworkCourseView.h
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/10/1.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "NotificationContentBaseView.h"

@interface HomeworkCourseView : NotificationContentBaseView
@property (nonatomic, strong)NSString*  course;
@property (nonatomic, copy)void (^addCallback)();
@end
