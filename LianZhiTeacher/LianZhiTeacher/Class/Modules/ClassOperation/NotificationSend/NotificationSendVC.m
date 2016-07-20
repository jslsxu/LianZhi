//
//  NotificationSendVC.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/6/30.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "NotificationSendVC.h"
@interface NotificationSendVC ()<NotificationInputDelegate, UIGestureRecognizerDelegate, UIScrollViewDelegate>
@end

@implementation NotificationSendVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发布通知";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"预览" style:UIBarButtonItemStylePlain target:self action:@selector(onPreview)];
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64)];
    [_scrollView setContentInset:UIEdgeInsetsMake(0, 0, kActionBarHeight, 0)];
    [_scrollView setShowsVerticalScrollIndicator:NO];
    [_scrollView setAlwaysBounceVertical:YES];
    [_scrollView setDelegate:self];
    [self setupScrollView];
    [self.view addSubview:_scrollView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSwipe)];
    [tapGesture setDelegate:self];
    [tapGesture setCancelsTouchesInView:NO];
    [_scrollView addGestureRecognizer:tapGesture];
    
    _inputView = [[NotificationInputView alloc] initWithFrame:CGRectMake(0, self.view.height - 64 - kActionBarHeight, self.view.width, kActionBarHeight)];
    [_inputView setDelegate:self];
    [self.view addSubview:_inputView];

}

- (void)onPreview{
    
}

- (void)onSwipe{
    if(_inputView.actionType != ActionTypeNone){
        [_inputView setActionType:ActionTypeNone];
    }
}

- (void)setupScrollView{
    UserInfo *userInfo = [UserCenter sharedInstance].userInfo;
    _targetContentView = [[NotificationTargetContentView alloc] initWithWidth:_scrollView.width targets:@[userInfo,userInfo,userInfo,userInfo,userInfo,userInfo,userInfo,userInfo,userInfo,userInfo,userInfo,userInfo,userInfo,userInfo]];
    [_targetContentView setAddBlk:^{
        
    }];
    [_scrollView addSubview:_targetContentView];
    
    _smsChoiceView = [[NotificationSendChoiceView alloc] initWithFrame:CGRectMake(0, _targetContentView.bottom, _scrollView.width, 54) title:@"连枝代发短信"];
    [_scrollView addSubview:_smsChoiceView];
    
    _timerSendView = [[NotificationSendChoiceView alloc] initWithFrame:CGRectMake(0, _smsChoiceView.bottom, _scrollView.width, 54) title:@"定时发送"];
    [_scrollView addSubview:_timerSendView];
}

#pragma mark - NotificationInputDelegate

- (void)notificationInputDidWillChangeHeight:(CGFloat)height{
    [UIView animateWithDuration:kActionAnimationDuration animations:^{
        [_inputView setY:self.view.height - height];
        [_scrollView setContentInset:UIEdgeInsetsMake(0, 0, height, 0)];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)notificationInputPhoto:(NotificationInputView *)inputView{
    
}
- (void)notificationInputVideo:(NotificationInputView *)inputView
{
    
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return YES;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([scrollView isTracking]) {
        [_inputView setActionType:ActionTypeNone];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
