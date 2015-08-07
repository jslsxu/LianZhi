//
//  RegisterVC.m
//  LianZhiParent
//
//  Created by jslsxu on 14/12/17.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "PhoneLoginVC.h"
#import "AuthCodeVC.h"

@interface PhoneLoginVC ()

@end

@implementation PhoneLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"手机号登录";
    
    _phoneNumField = [[LZTextField alloc] initWithFrame:CGRectMake(25, 20, self.view.width - 25 * 2, 45)];
    [_phoneNumField setFont:[UIFont systemFontOfSize:16]];
    [_phoneNumField setTextColor:kCommonTeacherTintColor];
    [_phoneNumField setReturnKeyType:UIReturnKeyDone];
    [_phoneNumField setKeyboardType:UIKeyboardTypeDecimalPad];
    [_phoneNumField setPlaceholder:@"请输入手机号"];
    [_phoneNumField setDelegate:self];
    [self.view addSubview:_phoneNumField];
    
    _registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_registerButton setFrame:CGRectMake(25 + _phoneNumField.width / 2, _phoneNumField.bottom + 15, _phoneNumField.width / 2, 45)];
    [_registerButton addTarget:self action:@selector(onRegisterClicked) forControlEvents:UIControlEventTouchUpInside];
    [_registerButton setBackgroundImage:[[UIImage imageNamed:MJRefreshSrcName(@"BlueBG.png")] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)] forState:UIControlStateNormal];
    [_registerButton.titleLabel setFont:kButtonTextFont];
    [_registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_registerButton setTitle:@"下一步" forState:UIControlStateNormal];
    [self.view addSubview:_registerButton];
}

- (void)onRegisterClicked
{
    [_phoneNumField resignFirstResponder];
     NSString *mobile = [[_phoneNumField text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if(![self checkPhoneNumber:mobile])
    {
        [ProgressHUD showHintText:@"请输入正确的手机号"];
        return;
    }
    RIButtonItem *cancelItem = [RIButtonItem itemWithTitle:@"取消"];
    RIButtonItem *confirmItem = [RIButtonItem itemWithTitle:@"确定"];
    __weak typeof(self) wself = self;
    [confirmItem setAction:^{
        
        MBProgressHUD *hud = [MBProgressHUD showMessag:@"" toView:self.view];
        [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"user/get_sms_code" method:REQUEST_GET type:REQUEST_REFRESH withParams:@{@"mobile":mobile} observer:self completion:^(AFHTTPRequestOperation *operation, TNDataWrapper* responseObject) {
            [hud hide:YES];
            [MBProgressHUD showSuccess:@"验证码已经发送" toView:self.view];
            AuthCodeVC *authCodeVC = [[AuthCodeVC alloc] init];
            [authCodeVC setLoginCallBack:self.loginCallBack];
            [authCodeVC setMobile:[_phoneNumField text]];
            __strong typeof(wself) sself = wself;
            [sself.navigationController pushViewController:authCodeVC animated:YES];
        } fail:^(NSString *errMsg) {
            [hud hide:YES];
            [ProgressHUD showHintText:errMsg];
        }];
    }];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"我们将要向此手机发送验证码" cancelButtonItem:cancelItem otherButtonItems:confirmItem, nil];
    [alertView show];
}

- (BOOL)checkPhoneNumber:(NSString *)phoneNumber
{
    NSString *mobile = @"^1\\d{10}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", mobile];
    return  [regextestmobile evaluateWithObject:phoneNumber];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
