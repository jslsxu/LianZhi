//
//  PasswordModificationVC.m
//  LianZhiParent
//  登陆成功，修改密码界面
//  Created by jslsxu on 14/12/19.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "PasswordModificationVC.h"

@interface PasswordModificationVC ()

@end

@implementation PasswordModificationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设置密码";
    _firstField = [[LZTextField alloc] initWithFrame:CGRectMake(25, 20, self.view.width - 25 * 2, 45)];
    [_firstField setFont:[UIFont systemFontOfSize:16]];
    [_firstField setTextColor:kCommonParentTintColor];
    [_firstField setReturnKeyType:UIReturnKeyDone];
    [_firstField setSecureTextEntry:YES];
    [_firstField setPlaceholder:@"请输入您的新密码"];
    [_firstField setDelegate:self];
    [self.view addSubview:_firstField];
    
    _secondField = [[LZTextField alloc] initWithFrame:CGRectMake(25, 15 + _firstField.bottom, self.view.width - 25 * 2, 45)];
    [_secondField setFont:[UIFont systemFontOfSize:16]];
    [_secondField setTextColor:kCommonParentTintColor];
    [_secondField setReturnKeyType:UIReturnKeyDone];
    [_secondField setSecureTextEntry:YES];
    [_secondField setPlaceholder:@"请再次输入新密码"];
    [_secondField setDelegate:self];
    [self.view addSubview:_secondField];
    
    _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_confirmButton setFrame:CGRectMake(self.view.width / 2, _secondField.bottom + 15, _secondField.width / 2, 45)];
    [_confirmButton addTarget:self action:@selector(onConfirmClicked) forControlEvents:UIControlEventTouchUpInside];
    [_confirmButton setBackgroundImage:[[UIImage imageNamed:@"GreenBG.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)] forState:UIControlStateNormal];
    [_confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_confirmButton.titleLabel setFont:kButtonTextFont];
    [_confirmButton setTitle:@"进入" forState:UIControlStateNormal];
    [self.view addSubview:_confirmButton];
}

- (void)onConfirmClicked
{
    [self.view endEditing:YES];
    NSString *first = [_firstField text];
    NSString *second = [_secondField text];
    if(![first isEqualToString:second])
    {
        [ProgressHUD showHintText:@"两次密码输入不一致"];
        return;
    }
    else if(first.length < 6 || first.length > 15)
    {
        [ProgressHUD showHintText:@"密码位数在6-15位"];
        return;
    }
    MBProgressHUD *hud = [MBProgressHUD showMessag:@"正在设置密码" toView:self.view];
    [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"setting/set_password" method:REQUEST_POST type:REQUEST_REFRESH withParams:@{@"password":first} observer:self completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
        NSString *token =[responseObject getStringForKey:@"verify"];
        [[UserCenter sharedInstance].userData setAccessToken:token];
        [[UserCenter sharedInstance] save];
        [hud hide:NO];
        [ProgressHUD showHintText:@"密码设置成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if(self.callback)
                self.callback();
        });
    } fail:^(NSString *errMsg) {
        [hud hide:NO];
        [ProgressHUD showHintText:errMsg];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
