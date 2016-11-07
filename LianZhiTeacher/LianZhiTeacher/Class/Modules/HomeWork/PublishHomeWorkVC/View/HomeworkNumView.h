//
//  HomeworkNumView.h
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/10/9.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeworkNumView : UIView
@property (nonatomic, assign)NSInteger numOfHomework;
@property (nonatomic, copy)void (^numChangedCallback)(NSInteger num);
@end
