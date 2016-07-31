//
//  NotificationInputView.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/6/30.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "NotificationInputView.h"
#import "DNImagePickerController.h"
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

        [self setActionType:ActionTypeNone];
    }
    return self;
}

- (void)showAudioRecordView{
    [_photoView removeFromSuperview];
    _photoView = nil;
    if(!_recordView){
        @weakify(self);
        _recordView = [[NotificationAudioRecordView alloc] initWithFrame:CGRectMake(0, kActionBarHeight, self.width, kActionContentHeight)];
        [_recordView setSendCallback:^(NSString *filePath, NSInteger duration) {
            @strongify(self);
            AudioItem *audioItem = [[AudioItem alloc] init];
            [audioItem setAudioUrl:filePath];
            [audioItem setTimeSpan:duration];
            if([self.delegate respondsToSelector:@selector(notificationInputAudio:audioItem:)]){
                [self.delegate notificationInputAudio:self audioItem:audioItem];
            }
        }];
        [self addSubview:_recordView];
    }
}

- (void)showImagePicker{
    [_recordView removeFromSuperview];
    _recordView = nil;
    if(!_photoView){
        @weakify(self);
        _photoView = [[QuickImagePickerView alloc] initWithMaxCount:9];
        [_photoView setOrigin:CGPointMake(0, kActionBarHeight)];
        [_photoView setOnClickAlbum:^{
            @strongify(self);
            if([self.delegate respondsToSelector:@selector(notificationInputPhoto:)]){
                [self.delegate notificationInputPhoto:self];
            }
        }];
        [_photoView setSendCallback:^(NSArray *photoArray, BOOL fullImage) {
            @strongify(self);
            if([self.delegate respondsToSelector:@selector(notificationInputQuickPhoto: fullImage:)])
                [self.delegate notificationInputQuickPhoto:photoArray fullImage:fullImage];
        }];
        [self addSubview:_photoView];
    }
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
        if(_actionType == i + 1 && i != ActionTypeCamera - ActionTypeRecordAudio){
            [actionButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_selected",imageArray[i]]] forState:UIControlStateNormal];
        }
        else{
            [actionButton setImage:[UIImage imageNamed:imageArray[i]] forState:UIControlStateNormal];
        }
    }
    CGFloat height = kActionBarHeight;
    if(_actionType == ActionTypeNone){
        [_photoView removeFromSuperview];
        _photoView = nil;
        [_recordView removeFromSuperview];
        _recordView = nil;
    }
    else if(_actionType == ActionTypeRecordAudio){
        [self showAudioRecordView];
        height = self.height;
    }
    else if(_actionType == ActionTypePhoto){
        [self showImagePicker];
        height = self.height;
    }
    else if(_actionType == ActionTypeCamera){
        if([self.delegate respondsToSelector:@selector(notificationInputVideo:)]){
            [self.delegate notificationInputVideo:self];
        }
    }
    if([self.delegate respondsToSelector:@selector(notificationInputDidWillChangeHeight:)]){
        [self.delegate notificationInputDidWillChangeHeight:height];
    }
}

- (void)onActionButtonClicked:(UIButton *)button{
    NSInteger index = [_actionButtonArray indexOfObject:button];
    ActionType type = index + ActionTypeRecordAudio;
    if(_actionType != type || type == ActionTypeCamera){
         [self setActionType:type];
    }
}

- (void)onSendClicked{
    
}

@end
