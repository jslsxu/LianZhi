//
//  HomeworkMarkFooterView.h
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/10/19.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeworkTeacherMark.h"
@interface HomeworkMarkFooterView : UIView

@property (nonatomic, strong)HomeworkTeacherMark*   teacherMark;
+ (MarkType)currentMarkType;
- (void)clearMark;
- (NSString *)comment;
@end
