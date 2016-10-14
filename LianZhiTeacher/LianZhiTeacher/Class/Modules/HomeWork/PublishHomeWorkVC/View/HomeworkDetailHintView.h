//
//  HomeworkDetailHintView.h
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/10/9.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeworkDetailHintView : UIView
+ (void)showWithTitle:(NSString *)title description:(NSString *)description completion:(void (^)(void))completion;
@end
