//
//  NotificationContentBaseView.h
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/7/29.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationContentBaseView : UIView
@property (nonatomic, assign)BOOL editDisabled;
@property (nonatomic, copy)void (^deleteDataCallback)(id item);
@end
