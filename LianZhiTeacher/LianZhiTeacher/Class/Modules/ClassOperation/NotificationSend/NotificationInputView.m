//
//  NotificationInputView.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/6/30.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "NotificationInputView.h"

@implementation NotificationInputView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        _actionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 40)];
        [self setupActionView:_actionView];
        [self addSubview:_actionView];
        
        _recordView = [[NotificationRecordView alloc] initWithFrame:CGRectMake(0, _actionView.height, self.width, 0)];
        [self addSubview:_recordView];
    }
    return self;
}

- (void)setupActionView:(UIView *)viewParent
{
    for (NSInteger i = 0; i < 3; i++) {
        UIButton *actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [actionButton setFrame:CGRectMake(50 * i, 0, 50, viewParent.height)];
        [actionButton setTag:1000 + i];
        [actionButton addTarget:self action:@selector(onActionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [viewParent addSubview:actionButton];
    }
}

- (void)onActionButtonClicked:(UIButton *)button{
    NSInteger tag = button.tag - 1000;
    if(tag == 0){
        
    }
    else if(tag == 1){
        if([self.delegate respondsToSelector:@selector(notificationInputPhoto:)]){
            [self.delegate notificationInputPhoto:self];
        }
    }
    else{
        if([self.delegate respondsToSelector:@selector(notificationInputVideo:)]){
            [self.delegate notificationInputVideo:self];
        }
    }

}

@end
