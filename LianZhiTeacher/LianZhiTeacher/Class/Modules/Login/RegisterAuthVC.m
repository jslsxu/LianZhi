//
//  RegisterAuthVC.m
//  LianZhiTeacher
//
//  Created by jslsxu on 15/9/26.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "RegisterAuthVC.h"
#define kRemainedSeconds                60
@interface RegisterAuthVC ()
@property (nonatomic, assign)NSInteger defaultRemain;
@property (nonatomic, strong)NSTimer *timer;
@end

@implementation RegisterAuthVC

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self cancelTimer];
}

- (void)viewDidLoad {
    [super viewDidLoad];
   self.title = @"手机验证";
    _authCodeFeild = [[LZTextField alloc] initWithFrame:CGRectMake(10, 40, self.view.width - 100, 35)];
    [_authCodeFeild setPlaceholder:@"请输入验证码"];
    [_authCodeFeild setTextColor:kCommonTeacherTintColor];
    [_authCodeFeild setFont:[UIFont systemFontOfSize:16]];
    [_authCodeFeild setKeyboardType:UIKeyboardTypeNumberPad];
    [self.view addSubview:_authCodeFeild];
    
    _retrieveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_retrieveButton.titleLabel setFont:kButtonTextFont];
    [_retrieveButton setTitle:@"验证码" forState:UIControlStateNormal];
    [_retrieveButton setFrame:CGRectMake(_authCodeFeild.right + 10, _authCodeFeild.y, 70, 35)];
    [_retrieveButton addTarget:self action:@selector(requestAuthCode) forControlEvents:UIControlEventTouchUpInside];
    [_retrieveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_retrieveButton setBackgroundImage:[[UIImage imageWithColor:kCommonTeacherTintColor size:CGSizeMake(30, 30) cornerRadius:5] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)] forState:UIControlStateNormal];
    [self.view addSubview:_retrieveButton];
    
    _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_nextButton setFrame:CGRectMake(10, _authCodeFeild.bottom + 10, self.view.width - 10 * 2, 40)];
    [_nextButton addTarget:self action:@selector(onNextClicked) forControlEvents:UIControlEventTouchUpInside];
    [_nextButton setBackgroundImage:[[UIImage imageWithColor:kCommonTeacherTintColor size:CGSizeMake(30, 30) cornerRadius:5] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)] forState:UIControlStateNormal];
    [_nextButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [_nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [_nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:_nextButton];
    
    [self requestAuthCode];
}

- (void)onNextClicked
{
    [self.view endEditing:YES];
    NSString *authCode = _authCodeFeild.text;
    if(authCode.length == 0)
    {
        [ProgressHUD showHintText:@"请输入验证码"];
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.mobile forKey:@"mobile"];
    [params setValue:self.name forKey:@"name"];
    [params setValue:self.school forKey:@"school"];
    [params setValue:self.area forKey:@"area"];
    MBProgressHUD *hud = [MBProgressHUD showMessag:@"" toView:[UIApplication sharedApplication].keyWindow];
    [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"user/account_apply" method:REQUEST_POST type:REQUEST_REFRESH withParams:params observer:nil completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
        [hud hide:NO];
        [ProgressHUD showHintText:@"申请成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popToRootViewControllerAnimated:YES];
        });
    } fail:^(NSString *errMsg) {
        [hud hide:NO];
        [ProgressHUD showHintText:errMsg];
    }];
}

- (void)requestAuthCode
{
    NSString *mobile = self.mobile;
    if([mobile isPhoneNumberValidate])
    {
        MBProgressHUD *hud = [MBProgressHUD showMessag:@"" toView:self.view];
        [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"user/get_sms_code" method:REQUEST_GET type:REQUEST_REFRESH withParams:@{@"mobile":mobile} observer:self completion:^(AFHTTPRequestOperation *operation, TNDataWrapper* responseObject) {
            [hud hide:YES];
            [MBProgressHUD showSuccess:@"验证码已经发送" toView:self.view];
            [self startTimer];
        } fail:^(NSString *errMsg) {
            [hud hide:YES];
            [ProgressHUD showHintText:errMsg];
        }];
    }
}


- (void)startTimer
{
    if(self.timer)
    {
        [self.timer invalidate];
    }
    [_retrieveButton setUserInteractionEnabled:NO];
    _defaultRemain = kRemainedSeconds;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
    [self.timer fire];
}


- (void)onTimer
{
    @synchronized (self)
    {
        if(_defaultRemain == 0)
        {
            [self cancelTimer];
        }
        else
        {
            _defaultRemain --;
            [_retrieveButton setTitle:[NSString stringWithFormat:@"%li秒",(long)_defaultRemain] forState:UIControlStateNormal];
        }
    }
}

- (void)cancelTimer
{
    [self.timer invalidate];
    self.timer = nil;
    [_retrieveButton setUserInteractionEnabled:YES];
    [_retrieveButton setTitle:@"验证码" forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
