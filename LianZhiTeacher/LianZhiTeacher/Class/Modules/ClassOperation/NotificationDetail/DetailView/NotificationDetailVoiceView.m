//
//  NotificationDetailVoiceView.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/7/30.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "NotificationDetailVoiceView.h"

@implementation NotificationDetailVoiceView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        UIView* sepLine = [[UIView alloc] initWithFrame:CGRectMake(10, 40, self.width - 10 * 2, kLineHeight)];
        [sepLine setBackgroundColor:kSepLineColor];
        [self addSubview:sepLine];
        
        [self setHeight:sepLine.bottom];
    }
    return self;
}

@end
