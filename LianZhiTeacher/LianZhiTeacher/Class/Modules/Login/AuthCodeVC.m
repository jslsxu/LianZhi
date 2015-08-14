//
//  AuthCodeVC.m
//  LianZhiParent
//
//  Created by jslsxu on 14/12/17.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "AuthCodeVC.h"

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
    
    _authCodeField = [[LZTextField alloc] initWithFrame:CGRectMake(25, 20, (self.view.width - 25 * 2 - 15) * 2 / 3, 45)];
    [_authCodeField setFont:[UIFont systemFontOfSize:16]];
    [_authCodeField setTextColor:kCommonTeacherTintColor];
    [_authCodeField setReturnKeyType:UIReturnKeyDone];
    [_authCodeField setKeyboardType:UIKeyboardTypeDecimalPad];
    [_authCodeField setPlaceholder:@"请输入收到的验证码"];
    [_authCodeField setDelegate:self];
    [self.view addSubview:_authCodeField];
    
    _retrieveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_retrieveButton.titleLabel setFont:kButtonTextFont];
    [_retrieveButton setFrame:CGRectMake(_authCodeField.right + 15, _authCodeField.y, _authCodeField.width / 2, 45)];
    [_retrieveButton addTarget:self action:@selector(retriveAuthCode) forControlEvents:UIControlEventTouchUpInside];
    [_retrieveButton setTitleColor:kCommonTeacherTintColor forState:UIControlStateNormal];
    [_retrieveButton setBackgroundImage:[[UIImage imageNamed:(@"WhiteBG.png")] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)] forState:UIControlStateNormal];
    [self.view addSubview:_retrieveButton];
    
    _nameField = [[LZTextField alloc] initWithFrame:CGRectMake(25, _authCodeField.bottom + 15, self.view.width - 25 * 2, 45)];
    [_nameField setFont:[UIFont systemFontOfSize:16]];
    [_nameField setTextColor:kCommonTeacherTintColor];
    [_nameField setReturnKeyType:UIReturnKeyDone];
    [_nameField setPlaceholder:@"请输入您的姓名"];
    [_nameField setDelegate:self];
    [self.view addSubview:_nameField];
    
    _authButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_authButton setFrame:CGRectMake(25, _nameField.bottom + 15, self.view.width - 25 * 2, 45)];
    [_authButton addTarget:self action:@selector(onLoginButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [_authButton setBackgroundImage:[[UIImage imageNamed:(@"BlueBG.png")] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)] forState:UIControlStateNormal];
    [_authButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [_authButton setTitle:@"验证并登录" forState:UIControlStateNormal];
    [_authButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:_authButton];
    
    [self startTimer];
}

- (void)requestAuthCode
{
    if([self.mobile length] > 0)
    {
        MBProgressHUD *hud = [MBProgressHUD showMessag:@"" toView:self.view];
        [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"user/get_sms_code" method:REQUEST_GET type:REQUEST_REFRESH withParams:@{@"mobile":self.mobile} observer:self completion:^(AFHTTPRequestOperation *operation, TNDataWrapper* responseObject) {
            [hud hide:YES];
            [MBProgressHUD showSuccess:@"验证码已经发送" toView:self.view];
            [self startTimer];
        } fail:^(NSString *errMsg) {
            [hud hide:YES];
        }];
    }
    else
    {
        TNButtonItem *confirmItem = [TNButtonItem itemWithTitle:@"确定" action:nil];
        TNAlertView *alertView = [[TNAlertView alloc] initWithTitle:@"请输入正确的手机号" buttonItems:@[confirmItem]];
        [alertView show];
    }
}

- (void)onLoginButtonClicked
{
    [self.view endEditing:YES];
    __weak typeof(self) wself = self;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.mobile forKey:@"mobile"];
    [params setValue:_nameField.text forKey:@"name"];
    [params setValue:_authCodeField.text forKey:@"code"];
    [params setValue:[UserCenter sharedInstance].deviceToken forKey:@"device_token"];
    [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"user/login_mobile" method:REQUEST_GET type:REQUEST_REFRESH withParams:params observer:self completion:^(AFHTTPRequestOperation *operation, TNDataWrapper* responseObject) {
        TNDataWrapper *schoolsWrapper = [responseObject getDataWrapperForKey:@"schools"];
        if(schoolsWrapper.count > 0)
        {
            [[UserCenter sharedInstance] parseData:responseObject];
            if(wself.loginCallBack)
                wself.loginCallBack(YES,NO);
        }
        else
        {
            TNButtonItem *item = [TNButtonItem itemWithTitle:@"确定" action:^{
                
            }];
            TNAlertView *alertView = [[TNAlertView alloc] initWithTitle:@"未找到您的学校，请联系管理员或客服人员" buttonItems:@[item]];
            [alertView show];
        }
        
    } fail:^(NSString *errMsg) {
        [ProgressHUD showHintText:errMsg];
    }];
}

- (void)retriveAuthCode
{
    [self requestAuthCode];
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

- (void)setupButtonSettings:(UIButton *)button
{
    [_retrieveButton setUserInteractionEnabled:YES];
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
    [self setupButtonSettings:_retrieveButton];
    [_retrieveButton setTitle:@"重发" forState:UIControlStateNormal];
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
