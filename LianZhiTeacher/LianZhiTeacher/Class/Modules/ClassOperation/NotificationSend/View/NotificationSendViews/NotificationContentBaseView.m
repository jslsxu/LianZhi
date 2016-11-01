//
//  NotificationContentBaseView.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/7/29.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "NotificationContentBaseView.h"

@implementation NotificationContentBaseView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self setClipsToBounds:YES];
    }
    return self;
}

- (void)setEditDisabled:(BOOL)editDisabled{
    _editDisabled = editDisabled;
    [self setUserInteractionEnabled:!_editDisabled];
}
@end
