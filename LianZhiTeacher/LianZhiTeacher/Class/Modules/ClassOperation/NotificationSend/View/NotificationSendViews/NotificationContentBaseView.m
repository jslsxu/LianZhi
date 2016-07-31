//
//  NotificationContentBaseView.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/7/29.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "NotificationContentBaseView.h"

@implementation NotificationContentBaseView

- (void)setFrame:(CGRect)frame{
    CGRect originalFrame = self.frame;
    if(!CGRectEqualToRect(originalFrame, frame)){
        [super setFrame:frame];
        
    }
}

@end
