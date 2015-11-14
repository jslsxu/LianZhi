//
//  AuthCodeVC.m
//  LianZhiParent
//
//  Created by jslsxu on 14/12/17.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "AuthCodeVC.h"
#import "PasswordConfirmVC.h"
#define kRemainedSeconds                60

@interface AuthCodeVC ()
@property (nonatomic, strong)NSTimer *timer;
@end

@implementation AuthCodeVC

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self cancelTimer];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"手机验证";
    
    _mobileField = [[LZTextField alloc] initWithFrame:CGRectMake(10, 20, self.view.width - 10 * 2, 45)];
    [_mobileField setFont:[UIFont systemFontOfSize:16]];
    [_mobileField setTextColor:kCommonTeacherTintColor];
    [_mobileField setReturnKeyType:UIReturnKeyDone];
    [_mobileField setKeyboardType:UIKeyboardTypeDecimalPad];
    [_mobileField setPlaceholder:@"请输入注册的手机号"];
    [_mobileField setDelegate:self];
    [self.view addSubview:_mobileField];
    
    _authCodeField = [[LZTextField alloc] initWithFrame:CGRectMake(10, _mobileField.bottom + 15, self.view.width - 10 *2 - 10 - 90, 45)];
    [_authCodeField setFont:[UIFont systemFontOfSize:16]];
    [_authCodeField setTextColor:kCommonTeacherTintColor];
    [_authCodeField setReturnKeyType:UIReturnKeyDone];
    [_authCodeField setKeyboardType:UIKeyboardTypeDecimalPad];
    [_authCodeField setPlaceholder:@"请输入收到的验证码"];
    [_authCodeField setDelegate:self];
    [self.view addSubview:_authCodeField];
    
    _retrieveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_retrieveButton.titleLabel setFont:kButtonTextFont];
    [_retrieveButton setTitle:@"验证码" forState:UIControlStateNormal];
    [_retrieveButton setFrame:CGRectMake(self.view.width - 10 - 90, _authCodeField.y, 90, 45)];
    [_retrieveButton addTarget:self action:@selector(requestAuthCode) forControlEvents:UIControlEventTouchUpInside];
    [_retrieveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_retrieveButton setBackgroundImage:[[UIImage imageWithColor:kCommonTeacherTintColor size:CGSizeMake(30, 30) cornerRadius:5] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)] forState:UIControlStateNormal];
    [self.view addSubview:_retrieveButton];
    
//    _nameField = [[LZTextField alloc] initWithFrame:CGRectMake(10, _authCodeField.bottom + 15, self.view.width - 10 * 2, 45)];
//    [_nameField setFont:[UIFont systemFontOfSize:16]];
//    [_nameField setTextColor:kCommonTeacherTintColor];
//    [_nameField setReturnKeyType:UIReturnKeyDone];
//    [_nameField setPlaceholder:@"请输入您的姓名"];
//    [_nameField setDelegate:self];
//    [self.view addSubview:_nameField];
    
    _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_nextButton setFrame:CGRectMake(10, _retrieveButton.bottom + 15, self.view.width - 10 * 2, 45)];
    [_nextButton addTarget:self action:@selector(onNextClicked) forControlEvents:UIControlEventTouchUpInside];
    [_nextButton setBackgroundImage:[[UIImage imageWithColor:kCommonTeacherTintColor size:CGSizeMake(30, 30) cornerRadius:5] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)] forState:UIControlStateNormal];
    [_nextButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [_nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [_nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:_nextButton];
}

- (void)requestAuthCode
{
    NSString *mobile = _mobileField.text;
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

- (void)onNextClicked
{
    [self.view endEditing:YES];
    NSString *mobile = _mobileField.text;
    NSString *authCode = _authCodeField.text;
//    NSString *name = _nameField.text;
    NSString *errMsg = nil;
    if(mobile.length == 0)
        errMsg = @"手机号不能为空";
    else if(authCode.length == 0)
        errMsg = @"请输入验证码";
//    else if (name.length == 0)
//        errMsg = @"请输入您的姓名";
    if(errMsg)
    {
        [ProgressHUD showHintText:errMsg];
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:mobile forKey:@"mobile"];
    [params setValue:authCode forKey:@"code"];
//    [params setValue:name forKey:@"name"];
    MBProgressHUD *hud = [MBProgressHUD showMessag:@"" toView:[UIApplication sharedApplication].keyWindow];
    [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"user/login_mobile" method:REQUEST_GET type:REQUEST_REFRESH withParams:params observer:nil completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
        [hud hide:NO];
        [[UserCenter sharedInstance] parseData:responseObject];
        PasswordConfirmVC *passwordConfirmVC = [[PasswordConfirmVC alloc] init];
        [self.navigationController pushViewController:passwordConfirmVC animated:YES];
    } fail:^(NSString *errMsg) {
        [hud hide:NO];
        [ProgressHUD showHintText:errMsg];
    }];

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

#pragma mark - UItextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if([string isEqualToString:@"\n"])
    {
        [textField resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
