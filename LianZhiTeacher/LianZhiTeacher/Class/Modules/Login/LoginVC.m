//
//  LoginVC.m
//  LianZhiParent
//
//  Created by jslsxu on 14/12/17.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "LoginVC.h"
#import "PhoneLoginVC.h"
#define kLoginUserNameKey               @"LoginUserNameKey"
@interface LoginVC ()
@property (nonatomic, copy)LoginCompletion completion;
@end

@implementation LoginVC

+ (void)presentLoginVCAnimation:(BOOL)animated completion:(LoginCompletion)compleciton
{
    LoginVC *loginVC = [[LoginVC alloc] init];
    [loginVC setCompletion:compleciton];
    TNBaseNavigationController *nav = [[TNBaseNavigationController alloc] initWithRootViewController:loginVC];
    [CurrentROOTNavigationVC presentViewController:nav animated:animated completion:^{
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"用户登录";
    
    _userNameField = [[LZTextField alloc] initWithFrame:CGRectMake(25, 20, self.view.width - 25 * 2, 45)];
    [_userNameField setFont:[UIFont systemFontOfSize:16]];
    [_userNameField setTextColor:kCommonTeacherTintColor];
    [_userNameField setReturnKeyType:UIReturnKeyDone];
    [_userNameField setKeyboardType:UIKeyboardTypeDecimalPad];
    [_userNameField setPlaceholder:@"请输入您注册的手机号"];
    [_userNameField setDelegate:self];
    [self.view addSubview:_userNameField];
    
    _passwordField = [[LZTextField alloc] initWithFrame:CGRectMake(25, _userNameField.bottom + 10, self.view.width - 25 * 2, 45)];
//    [_passwordField addTarget:self action:@selector(checkPassword) forControlEvents:UIControlEventEditingChanged];
    [_passwordField setSecureTextEntry:YES];
    [_passwordField setFont:[UIFont systemFontOfSize:16]];
    [_passwordField setTextColor:kCommonTeacherTintColor];
    [_passwordField setReturnKeyType:UIReturnKeyDone];
    [_passwordField setPlaceholder:@"请输入您的登录密码"];
    [_passwordField setDelegate:self];
    [self.view addSubview:_passwordField];
    
    _registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_registerButton setFrame:CGRectMake(25, _passwordField.bottom + 20, (_passwordField.width - 25 * 2) * 0.6, 45)];
    [_registerButton addTarget:self action:@selector(onPhoneLoginClicked) forControlEvents:UIControlEventTouchUpInside];
    [_registerButton setTitle:@"手机号登录" forState:UIControlStateNormal];
    [_registerButton setTitleColor:kCommonTeacherTintColor forState:UIControlStateNormal];
    [_registerButton.titleLabel setFont:kButtonTextFont];
    [self.view addSubview:_registerButton];
    
    _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_loginButton setFrame:CGRectMake(_registerButton.right, _registerButton.y, _passwordField.right - _registerButton.right, 45)];
    [_loginButton addTarget:self action:@selector(onLoginClicked) forControlEvents:UIControlEventTouchUpInside];
    [_loginButton setBackgroundImage:[[UIImage imageNamed:MJRefreshSrcName(@"BlueBG.png")] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)] forState:UIControlStateNormal];
    [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_loginButton.titleLabel setFont:kButtonTextFont];
    [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [self.view addSubview:_loginButton];

}

- (void)setupSubviews
{
    UILabel*    hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.height - 80, self.view.width, 80)];
    [hintLabel setFont:[UIFont systemFontOfSize:12]];
    [hintLabel setTextColor:[UIColor lightGrayColor]];
    [hintLabel setNumberOfLines:0];
    [hintLabel setTextAlignment:NSTextAlignmentCenter];
    [hintLabel setText:@"请输入在学校预留的手机号码\n忘记密码可点击“手机号登录”"];
    [self.view addSubview:hintLabel];
}

- (void)onPhoneLoginClicked
{
    PhoneLoginVC *phoneLoginVC = [[PhoneLoginVC alloc] init];
    [phoneLoginVC setLoginCallBack:self.completion];
    [self.navigationController pushViewController:phoneLoginVC animated:YES];
}

- (void)onLoginClicked
{
    if([self checkInput])
    {
        [self.view endEditing:YES];
        NSString *username = [_userNameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSString *password = [_passwordField text];
        
//        NSString *serviceName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"];
//        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//        [userDefaults setValue:username forKey:kLoginUserNameKey];
//        [userDefaults synchronize];
//        [SFHFKeychainUtils storeUsername:username andPassword:password forServiceName:serviceName updateExisting:YES error:nil];
        //登录接口
        MBProgressHUD *hud = [MBProgressHUD showMessag:@"正在登录" toView:self.view];
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setValue:username forKey:@"mobile"];
        [params setValue:password forKey:@"password"];
        [params setValue:[UserCenter sharedInstance].deviceToken forKey:@"device_token"];
        
        [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"user/login" method:REQUEST_GET type:REQUEST_REFRESH withParams:params observer:nil completion:^(AFHTTPRequestOperation *operation, TNDataWrapper * responseObject) {
            [hud hide:YES];
            TNDataWrapper *schoolsWrapper = [responseObject getDataWrapperForKey:@"schools"];
            if(schoolsWrapper.count > 0)
            {
                [[UserCenter sharedInstance] parseData:responseObject];
                [self dismissViewControllerAnimated:YES completion:nil];
                if(self.completion)
                {
                    self.completion(YES,NO);
                }
            }
            else
            {
                TNButtonItem *item = [TNButtonItem itemWithTitle:@"确定" action:^{
                    
                }];
                TNAlertView *alertView = [[TNAlertView alloc] initWithTitle:@"未找到您的学校，请联系管理员或客服人员" buttonItems:@[item]];
                [alertView show];
            }
        
            } fail:^(NSString *errMsg) {
                [hud hide:NO];
                [MBProgressHUD showError:errMsg toView:self.view];
                if(self.completion)
                {
                    self.completion(NO,NO);
                }
        }];
    }
}

- (void)onServiceClicked
{
    
}

- (BOOL)checkPhoneNumber:(NSString *)phoneNumber
{
    NSString *mobile = @"^1\\d{10}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", mobile];
    return  [regextestmobile evaluateWithObject:phoneNumber];
}

- (BOOL)checkInput
{
    NSString *username = [[_userNameField text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = [_passwordField text];
    if(username.length ==0 || password.length == 0)
    {
        [ProgressHUD showHintText:@"手机号或密码不能为空"];
        return NO;
    }
    if(![self checkPhoneNumber:username])
    {
        [ProgressHUD showHintText:@"请输入正确的手机号"];
        return NO;
    }
    return YES;
}

- (void)checkPassword
{
    NSString *password = _passwordField.text;
    if(password.length >= 15)
    {
        [ProgressHUD showHintText:@"密码不能超过15位"];
        [_passwordField setText:[password substringToIndex:15]];
    }
}

#pragma mark UITextFieldDelegate
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
