//
//  NotificationInputView.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/6/30.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "NotificationInputView.h"

@interface NotificationInputView ()
@property(nonatomic, weak)UIView* currentActionView;
@end

@implementation NotificationInputView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self setBackgroundColor:[UIColor whiteColor]];
        [self setHeight:kActionBarHeight + kActionContentHeight];
        _actionButtonArray = [NSMutableArray array];
        _actionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, kActionBarHeight)];
        [self setupActionView:_actionView];
        [self addSubview:_actionView];
        
        _recordView = [[NotificationRecordView alloc] initWithFrame:CGRectMake(0, self.height, self.width, kActionContentHeight)];
        [self addSubview:_recordView];
        
        _photoView = [[QuickImagePickerView alloc] initWithMaxCount:9];
        [_photoView setOrigin:CGPointMake(0, self.height)];
        [self addSubview:_photoView];

        [self setActionType:ActionTypeNone];
    }
    return self;
}

- (void)setupActionView:(UIView *)viewParent
{
    for (NSInteger i = 0; i < 3; i++) {
        UIButton *actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [actionButton setFrame:CGRectMake(50 * i, 0, 50, viewParent.height)];
        [actionButton addTarget:self action:@selector(onActionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [viewParent addSubview:actionButton];
        [_actionButtonArray addObject:actionButton];
    }

    _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_sendButton setFrame:CGRectMake(viewParent.width - 10 - 70, (viewParent.height - 32) / 2, 70, 32)];
    [_sendButton setBackgroundImage:[UIImage imageWithColor:kCommonTeacherTintColor size:_sendButton.size cornerRadius:5] forState:UIControlStateNormal];
    [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [_sendButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [_sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_sendButton addTarget:self action:@selector(onSendClicked) forControlEvents:UIControlEventTouchUpInside];
    [viewParent addSubview:_sendButton];
    
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewParent.width, kLineHeight)];
    [topLine setBackgroundColor:kSepLineColor];
    [viewParent addSubview:topLine];
    
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, viewParent.height - kLineHeight, viewParent.width, kLineHeight)];
    [bottomLine setBackgroundColor:kSepLineColor];
    [viewParent addSubview:bottomLine];
}

- (void)setActionType:(ActionType)actionType{
    _actionType = actionType;
    NSArray *imageArray = @[@"action_record_audio",@"action_photo",@"action_camera"];
    for (NSInteger i = 0; i < _actionButtonArray.count; i++) {
        UIButton *actionButton = _actionButtonArray[i];
        if(_actionType == i + 1){
            [actionButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_selected",imageArray[i]]] forState:UIControlStateNormal];
        }
        else{
            [actionButton setImage:[UIImage imageNamed:imageArray[i]] forState:UIControlStateNormal];
        }
    }
    UIView *targetView = nil;
    CGFloat height = kActionBarHeight;
    if(_actionType == ActionTypeRecordAudio){
        targetView = _recordView;
        height = self.height;
    }
    else if(_actionType == ActionTypePhoto){
        targetView = _photoView;
        height = self.height;
    }
    BOOL heightChanged = (self.currentActionView.height != targetView.height);
    CGFloat duration = kActionAnimationDuration;
    if(!self.currentActionView)
        duration = 0;
    if(_actionType != ActionTypeNone && _actionType != ActionTypeCamera){
        [UIView animateWithDuration:duration animations:^{
            [self.currentActionView setY:self.height];
            [targetView setY:kActionBarHeight];
        } completion:^(BOOL finished) {
            self.currentActionView = targetView;
        }];
    }
    else{
        self.currentActionView = targetView;
    }

    if(heightChanged){
        if([self.delegate respondsToSelector:@selector(notificationInputDidWillChangeHeight:)]){
            [self.delegate notificationInputDidWillChangeHeight:height];
        }
    }
}

- (void)onActionButtonClicked:(UIButton *)button{
    NSInteger index = [_actionButtonArray indexOfObject:button];
    ActionType type = index + ActionTypeRecordAudio;
    if(type != _actionType){
        [self setActionType:type];
    }
    if(index == 0){
        
    }
    else if(index == 1){
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

- (void)onSendClicked{
    
}

@end
