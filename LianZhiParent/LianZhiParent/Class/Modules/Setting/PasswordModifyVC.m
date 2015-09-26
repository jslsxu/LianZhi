//
//  PasswordModifyVC.m
//  LianZhiParent
//
//  Created by jslsxu on 15/1/12.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "PasswordModifyVC.h"

@implementation PasswordModifyVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"修改密码";
}

- (void)setupSubviews
{
    CGFloat spaceYStart = 20;
    _originalPasswordField = [[LZTextField alloc] initWithFrame:CGRectMake(15, spaceYStart, self.view.width - 15 * 2, 45)];
    [_originalPasswordField setFont:[UIFont systemFontOfSize:16]];
    [_originalPasswordField setTextColor:kCommonParentTintColor];
    [_originalPasswordField setReturnKeyType:UIReturnKeyDone];
    [_originalPasswordField setSecureTextEntry:YES];
    [_originalPasswordField setPlaceholder:@"请输入您的旧密码"];
    [_originalPasswordField setDelegate:self];
    [self.view addSubview:_originalPasswordField];
    
    spaceYStart += 45 + 15;
    _newPasswordField = [[LZTextField alloc] initWithFrame:CGRectMake(15, spaceYStart, self.view.width - 15 * 2, 45)];
    [_newPasswordField addTarget:self action:@selector(checkPassword:) forControlEvents:UIControlEventEditingChanged];
    [_newPasswordField setFont:[UIFont systemFontOfSize:16]];
    [_newPasswordField setTextColor:kCommonParentTintColor];
    [_newPasswordField setReturnKeyType:UIReturnKeyDone];
    [_newPasswordField setSecureTextEntry:YES];
    [_newPasswordField setPlaceholder:@"请输入您的新密码"];
    [_newPasswordField setDelegate:self];
    [self.view addSubview:_newPasswordField];
    
    spaceYStart += 45 + 15;
    _confirmPasswordField = [[LZTextField alloc] initWithFrame:CGRectMake(15, spaceYStart, self.view.width - 15 * 2, 45)];
    [_confirmPasswordField addTarget:self action:@selector(checkPassword:) forControlEvents:UIControlEventEditingChanged];
    [_confirmPasswordField setFont:[UIFont systemFontOfSize:16]];
    [_confirmPasswordField setTextColor:kCommonParentTintColor];
    [_confirmPasswordField setReturnKeyType:UIReturnKeyDone];
    [_confirmPasswordField setSecureTextEntry:YES];
    [_confirmPasswordField setPlaceholder:@"请重复输入您的新密码"];
    [_confirmPasswordField setDelegate:self];
    [self.view addSubview:_confirmPasswordField];
    
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveButton setFrame:CGRectMake(15, _confirmPasswordField.bottom + 15, _confirmPasswordField.width, 45)];
    [saveButton addTarget:self action:@selector(onSaveClicked) forControlEvents:UIControlEventTouchUpInside];
    [saveButton setBackgroundImage:[UIImage imageWithColor:kCommonParentTintColor size:saveButton.size cornerRadius:5] forState:UIControlStateNormal];
    [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [saveButton setTitle:@"确定保存新密码" forState:UIControlStateNormal];
    [self.view addSubview:saveButton];
    
    UILabel *hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.height - 50, self.view.width, 50)];
    [hintLabel setBackgroundColor:[UIColor clearColor]];
    [hintLabel setFont:[UIFont systemFontOfSize:12]];
    [hintLabel setTextColor:[UIColor lightGrayColor]];
    [hintLabel setNumberOfLines:0];
    [hintLabel setTextAlignment:NSTextAlignmentCenter];
    [hintLabel setText:@"如您忘记密码，请联系我们的客服。\n客服电话：400-66-10016"];
    [self.view addSubview:hintLabel];
}

- (void)onSaveClicked
{
    [self.view endEditing:YES];
    NSString *originalPassowrd = [_originalPasswordField text];
    NSString *newPassowrd = [_newPasswordField text];
    NSString *confirmPassword = [_confirmPasswordField text];
    NSString *errMsg = nil;
    if(originalPassowrd.length == 0)
        errMsg = @"原密码不能为空";
    else if(newPassowrd.length == 0)
        errMsg = @"新密码不能为空";
    else if(newPassowrd.length < 6)
    {
        errMsg = @"密码长度不能少于6位";
    }
    else if(newPassowrd.length > 15)
    {
        errMsg = @"密码长不读不能超过15位";
    }
    else if([confirmPassword isEqualToString:newPassowrd] == NO)
        errMsg = @"两次密码不一致";
    if(errMsg)
    {
        [ProgressHUD showHintText:errMsg];
    }
    else
    {
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setValue:originalPassowrd forKey:@"old_password"];
        [params setValue:newPassowrd forKey:@"new_password"];
        MBProgressHUD *hud = [MBProgressHUD showMessag:@"" toView:self.view];
        [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"setting/update_password" method:REQUEST_POST type:REQUEST_REFRESH withParams:params observer:self completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
//            NSString *token =[responseObject getStringForKey:@"verify"];
//            [[UserCenter sharedInstance].userData setAccessToken:token];
//            [[UserCenter sharedInstance] save];
            [hud hide:NO];
            [ProgressHUD showHintText:@"密码修改成功,请重新登录"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [ApplicationDelegate logout];
            });
        } fail:^(NSString *errMsg) {
            [hud hide:NO];
            [ProgressHUD showHintText:errMsg];
        }];
    }
}

- (void)checkPassword:(UITextField *)textField
{
    NSString *password = textField.text;
    if(password.length >= 15)
    {
        [ProgressHUD showHintText:@"密码不能超过15位"];
        [textField setText:[password substringToIndex:15]];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if([string isEqualToString:@"\n"])
    {
        [textField resignFirstResponder];
        return NO;
    }
    return YES;
}
@end
