//
//  LoginVC.m
//  LianZhiParent
//
//  Created by jslsxu on 14/12/17.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "LoginVC.h"
#import "PhoneLoginVC.h"
#import "ConfimInfoVC.h"
#import "AuthCodeVC.h"
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
    self.title = @"用户登录";
    [self.view setBackgroundColor:kCommonParentTintColor];
    
    UIView *inputView = [[UIView alloc] initWithFrame:CGRectMake(20, 150, self.view.width - 20 * 2, 90)];
    [self setupInputView:inputView];
    [self.view addSubview:inputView];
    
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginButton setFrame:CGRectMake(20, inputView.bottom + 20, inputView.width, 40)];
    [loginButton addTarget:self action:@selector(onLoginClicked) forControlEvents:UIControlEventTouchUpInside];
    [loginButton setBackgroundImage:[[UIImage imageWithColor:[UIColor colorWithHexString:@"9cfc5e"] size:CGSizeMake(20, 20) cornerRadius:5] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)] forState:UIControlStateNormal];
    [loginButton setTitleColor:kCommonParentTintColor forState:UIControlStateNormal];
    [loginButton.titleLabel setFont:kButtonTextFont];
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [self.view addSubview:loginButton];
    
    UIButton *retriveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [retriveButton setFrame:CGRectMake(20, loginButton.bottom + 10, 75, 20)];
    [retriveButton addTarget:self action:@selector(onRetriveButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [retriveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [retriveButton setTitle:@"忘记密码?" forState:UIControlStateNormal];
    [retriveButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [self.view addSubview:retriveButton];
    
    UIButton *activateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [activateButton setFrame:CGRectMake(self.view.width - 20 - 75, loginButton.bottom + 10, 75, 20)];
    [activateButton addTarget:self action:@selector(onActivateButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [activateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [activateButton setTitle:@"新用户激活" forState:UIControlStateNormal];
    [activateButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [self.view addSubview:activateButton];
    
    UILabel*    hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.height - 80, self.view.width, 80)];
    [hintLabel setFont:[UIFont systemFontOfSize:12]];
    [hintLabel setTextColor:[UIColor colorWithHexString:@"047758"]];
    [hintLabel setNumberOfLines:0];
    [hintLabel setTextAlignment:NSTextAlignmentCenter];
    [hintLabel setText:@"账号首次登录请点击新用户激活"];
    [self.view addSubview:hintLabel];
}

- (void)setupInputView:(UIView *)viewParent
{
    [viewParent setBackgroundColor:[UIColor whiteColor]];
    [viewParent.layer setCornerRadius:5];
    [viewParent.layer setMasksToBounds:YES];
    
    UIImageView *userLeft = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"UserFieldIcon"]];
    [userLeft setOrigin:CGPointMake(10, (45 - userLeft.height) / 2)];
    [viewParent addSubview:userLeft];
    
    _userNameField = [[UITextField alloc] initWithFrame:CGRectMake(5 + userLeft.right, 0, viewParent.width - 10 - 10 - (5 + userLeft.right), 45)];
    [_userNameField setFont:[UIFont systemFontOfSize:15]];
    [_userNameField setTextColor:kCommonParentTintColor];
    [_userNameField setReturnKeyType:UIReturnKeyDone];
    [_userNameField setKeyboardType:UIKeyboardTypeDecimalPad];
    [_userNameField setPlaceholder:@"请输入您注册的手机号/连枝号"];
    [_userNameField setDelegate:self];
    [viewParent addSubview:_userNameField];
    
    UIView *sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, 45, viewParent.width, kLineHeight)];
    [sepLine setBackgroundColor:kSepLineColor];
    [viewParent addSubview:sepLine];
    
    UIImageView *passwordleft = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PasswordFieldIcon"]];
    [passwordleft setOrigin:CGPointMake(10, (45 - userLeft.height) / 2 + 45)];
    [viewParent addSubview:passwordleft];
    
    _passwordField = [[UITextField alloc] initWithFrame:CGRectMake(5 + passwordleft.right, 45, viewParent.width - 10 * 2 - (5 + passwordleft.right), 45)];
    [_passwordField setSecureTextEntry:YES];
    [_passwordField setFont:[UIFont systemFontOfSize:15]];
    [_passwordField setTextColor:kCommonParentTintColor];
    [_passwordField setReturnKeyType:UIReturnKeyDone];
    [_passwordField setPlaceholder:@"请输入您的登录密码"];
    [_passwordField setDelegate:self];
    [viewParent addSubview:_passwordField];
}

- (void)onRetriveButtonClicked
{
    AuthCodeVC *authCodeVC = [[AuthCodeVC alloc] init];
    [self.navigationController pushViewController:authCodeVC animated:YES];
}

- (void)onActivateButtonClicked
{
    AuthCodeVC *authCodeVC = [[AuthCodeVC alloc] init];
    [self.navigationController pushViewController:authCodeVC animated:YES];
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
        
//        //保存到keychain
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

            TNDataWrapper *childrenWrapper = [responseObject getDataWrapperForKey:@"children"];
            //检查信息
            if(childrenWrapper.count == 0)//没有孩子
            {
                TNButtonItem *item = [TNButtonItem itemWithTitle:@"确定" action:^{
                    
                }];
                TNAlertView *alertView = [[TNAlertView alloc] initWithTitle:@"未找到您的孩子，请联系管理员或客服人员" buttonItems:@[item]];
                [alertView show];
            }
            else
            {
                 [[UserCenter sharedInstance] parseData:responseObject];
                [self dismissViewControllerAnimated:YES completion:nil];
                if(self.completion)
                {
                    self.completion(YES,NO);
                }
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
