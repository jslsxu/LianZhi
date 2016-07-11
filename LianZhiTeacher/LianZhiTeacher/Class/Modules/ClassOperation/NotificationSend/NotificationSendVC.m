//
//  NotificationSendVC.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/6/30.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "NotificationSendVC.h"
#import "NotificationSendTargetView.h"
#import "NotificationInputView.h"
@interface NotificationSendVC ()<NotificationInputDelegate>
@property (nonatomic, strong)NotificationInputView *inputView;
@end

@implementation NotificationSendVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发布通知";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"预览" style:UIBarButtonItemStylePlain target:self action:@selector(onPreview)];
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [_scrollView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [_scrollView setShowsVerticalScrollIndicator:NO];
    [self.view addSubview:_scrollView];
}

- (void)onPreview{
    
}

- (void)setupScrollView{
    
}

- (NotificationInputView *)inputView{
    if(_inputView == nil){
        _inputView = [[NotificationInputView alloc] initWithFrame:CGRectMake(0, 0, _scrollView.width, 40)];
        [_inputView setDelegate:self];
    }
    return _inputView;
}

#pragma mark - NotificationInputDelegate

- (void)notificationInputPhoto:(NotificationInputView *)inputView{
    
}
- (void)notificationInputVideo:(NotificationInputView *)inputView
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
