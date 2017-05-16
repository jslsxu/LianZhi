//
//  LoginVC.m
//  LianZhiParent
//
//  Created by jslsxu on 14/12/17.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "LoginVC.h"
#import "RegisterVC.h"
#import "StatusManager.h"
#import "PhoneInputVC.h"
#define kLoginUserNameKey               @"LoginUserNameKey"
@interface LoginVC ()
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

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
        self.hideNavigationBar = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [ApplicationDelegate setupCommonAppearance];
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"teacher_login_bg.jpg"]];
    [bgImageView setFrame:self.view.bounds];
    [bgImageView setContentMode:UIViewContentModeScaleAspectFill];
    [self.view addSubview:bgImageView];
    
    UITouchScrollView*  scrollView = [[UITouchScrollView alloc] initWithFrame:self.view.bounds];
    [scrollView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [scrollView setShowsVerticalScrollIndicator:NO];
    [scrollView setAlwaysBounceVertical:YES];
    [self.view addSubview:scrollView];
    
    UIImageView* logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Icon"]];
    [logoView setOrigin:CGPointMake((scrollView.width - logoView.width) / 2, 60)];
    [scrollView addSubview:logoView];
    
    UILabel*    nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [nameLabel setText:@"连枝教师版"];
    [nameLabel setFont:[UIFont systemFontOfSize:15]];
    [nameLabel setTextColor:[UIColor colorWithHexString:@"2c2c2c"]];
    [nameLabel sizeToFit];
    [nameLabel setOrigin:CGPointMake((scrollView.width - nameLabel.width) / 2, logoView.bottom + 10)];
    [scrollView addSubview:nameLabel];
    
    UIView *inputView = [[UIView alloc] initWithFrame:CGRectMake(10, nameLabel.bottom + 30, scrollView.width - 10 * 2, 90)];
    [self setupInputView:inputView];
    [scrollView addSubview:inputView];
    
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginButton setFrame:CGRectMake(10, inputView.bottom + 20, scrollView.width - 10 * 2, 40)];
    [loginButton addTarget:self action:@selector(onLoginClicked) forControlEvents:UIControlEventTouchUpInside];
    [loginButton setBackgroundImage:[[UIImage imageWithColor:kCommonTeacherTintColor size:CGSizeMake(20, 20) cornerRadius:5] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)] forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginButton.titleLabel setFont:kButtonTextFont];
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [scrollView addSubview:loginButton];
    
    UIButton *activateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [activateButton addTarget:self action:@selector(onActivateButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [activateButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [activateButton setTitleColor:kCommonTeacherTintColor forState:UIControlStateNormal];
    [activateButton setTitle:@"新用户激活" forState:UIControlStateNormal];
    [activateButton sizeToFit];
    [activateButton setOrigin:CGPointMake(scrollView.width - activateButton.width - 10, loginButton.bottom + 10)];
    [scrollView addSubview:activateButton];
    
    
    UIButton *retriveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [retriveButton addTarget:self action:@selector(onRetriveButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [retriveButton setTitleColor:kCommonTeacherTintColor forState:UIControlStateNormal];
    [retriveButton setTitle:@"忘记密码?" forState:UIControlStateNormal];
    [retriveButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [retriveButton sizeToFit];
    [retriveButton setOrigin:CGPointMake(10, loginButton.bottom + 10)];
    [scrollView addSubview:retriveButton];
    
    UIButton *registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [registerButton addTarget:self action:@selector(onRegisterClicked) forControlEvents:UIControlEventTouchUpInside];
    [registerButton setTitle:@"没有开通连枝的学校请点我" forState:UIControlStateNormal];
    [registerButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [registerButton setTitleColor:kCommonTeacherTintColor forState:UIControlStateNormal];
    [registerButton setFrame:CGRectMake(0, self.view.height - 60, self.view.width, 60)];
    [self.view addSubview:registerButton];
}

- (void)setupInputView:(UIView *)viewParent
{
    _userNameField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, viewParent.width , 44)];
    [_userNameField setFont:[UIFont systemFontOfSize:15]];
    [_userNameField setTextColor:kCommonTeacherTintColor];
    [_userNameField setReturnKeyType:UIReturnKeyDone];
    [_userNameField setKeyboardType:UIKeyboardTypeDecimalPad];
    [_userNameField setPlaceholder:@"请输入您注册的手机号/连枝号"];
    [_userNameField setDelegate:self];
    [viewParent addSubview:_userNameField];
    
    UIView *sepLineUserName = [[UIView alloc] initWithFrame:CGRectMake(0, _userNameField.bottom, viewParent.width, kLineHeight)];
    [sepLineUserName setBackgroundColor:kSepLineColor];
    [viewParent addSubview:sepLineUserName];
    
    _passwordField = [[UITextField alloc] initWithFrame:CGRectMake(0, sepLineUserName.bottom, viewParent.width , 44)];
    [_passwordField setSecureTextEntry:YES];
    [_passwordField setFont:[UIFont systemFontOfSize:15]];
    [_passwordField setTextColor:kCommonTeacherTintColor];
    [_passwordField setReturnKeyType:UIReturnKeyDone];
    [_passwordField setPlaceholder:@"请输入您的登录密码"];
    [_passwordField setDelegate:self];
    [viewParent addSubview:_passwordField];
    
    UIView *sepLinePassword = [[UIView alloc] initWithFrame:CGRectMake(0, _passwordField.bottom, viewParent.width, kLineHeight)];
    [sepLinePassword setBackgroundColor:kSepLineColor];
    [viewParent addSubview:sepLinePassword];
}

- (void)onRegisterClicked
{
    RegisterVC *registerVC = [[RegisterVC alloc] init];
    [registerVC setLoginCompletion:self.completion];
    [self.navigationController pushViewController:registerVC animated:YES];
}

- (void)onRetriveButtonClicked
{
    PhoneInputVC *phoneInputVC = [[PhoneInputVC alloc] init];
    [CurrentROOTNavigationVC presentViewController:phoneInputVC animated:YES completion:nil];
}

- (void)onActivateButtonClicked
{
    PhoneInputVC *phoneInputVC = [[PhoneInputVC alloc] init];
    [CurrentROOTNavigationVC presentViewController:phoneInputVC animated:YES completion:nil];
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
                [[UserCenter sharedInstance] updateSchoolInfo];
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
