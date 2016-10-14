//
//  HomeworkReplySwitchView.h
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/10/9.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeworkReplySwitchView : UIView
@property (nonatomic, assign)BOOL replyOn;
@property (nonatomic, copy)void (^replySwitchCallback)(BOOL isOn);
@end
